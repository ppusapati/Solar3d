package service

import (
	"math"
	"time"

	"p9e.in/samavaya/solar3d/simulation-service/internal/domain"
)

const (
	degToRad = math.Pi / 180.0
	radToDeg = 180.0 / math.Pi
)

// CalculateSunPosition computes the solar position using astronomical algorithms
// based on Jean Meeus' "Astronomical Algorithms" and the NOAA Solar Calculator.
func CalculateSunPosition(lat, lon float64, ts time.Time) domain.SunPosition {
	ts = ts.UTC()

	// Julian Day Number
	jd := julianDay(ts)

	// Julian Century from J2000.0
	jc := (jd - 2451545.0) / 36525.0

	// Geometric mean longitude of the Sun (degrees)
	geomMeanLonSun := math.Mod(280.46646+jc*(36000.76983+0.0003032*jc), 360.0)

	// Geometric mean anomaly of the Sun (degrees)
	geomMeanAnomSun := 357.52911 + jc*(35999.05029-0.0001537*jc)

	// Eccentricity of Earth's orbit
	eccentEarthOrbit := 0.016708634 - jc*(0.000042037+0.0000001267*jc)

	// Sun's equation of center (degrees)
	sinM := math.Sin(geomMeanAnomSun * degToRad)
	sin2M := math.Sin(2.0 * geomMeanAnomSun * degToRad)
	sin3M := math.Sin(3.0 * geomMeanAnomSun * degToRad)
	sunEqOfCenter := sinM*(1.914602-jc*(0.004817+0.000014*jc)) +
		sin2M*(0.019993-0.000101*jc) +
		sin3M*0.000289

	// Sun's true longitude (degrees)
	sunTrueLon := geomMeanLonSun + sunEqOfCenter

	// Sun's true anomaly (degrees)
	sunTrueAnom := geomMeanAnomSun + sunEqOfCenter

	// Sun's radius vector (AU) — Earth-Sun distance used for irradiance correction.
	// The extraterrestrial irradiance scales as 1/R^2.
	sunRadiusVector := (1.000001018 * (1 - eccentEarthOrbit*eccentEarthOrbit)) /
		(1 + eccentEarthOrbit*math.Cos(sunTrueAnom*degToRad))

	// Sun's apparent longitude (degrees)
	omega := 125.04 - 1934.136*jc
	sunApparentLon := sunTrueLon - 0.00569 - 0.00478*math.Sin(omega*degToRad)

	// Mean obliquity of the ecliptic (degrees)
	meanObliqEcliptic := 23.0 + (26.0+(21.448-jc*(46.815+jc*(0.00059-jc*0.001813)))/60.0)/60.0

	// Corrected obliquity (degrees)
	obliqCorr := meanObliqEcliptic + 0.00256*math.Cos(omega*degToRad)

	// Solar declination (degrees)
	sinDec := math.Sin(obliqCorr*degToRad) * math.Sin(sunApparentLon*degToRad)
	declination := math.Asin(sinDec) * radToDeg

	// Equation of time (minutes)
	y := math.Tan(obliqCorr/2.0*degToRad) * math.Tan(obliqCorr/2.0*degToRad)
	eqOfTime := 4.0 * radToDeg * (y*math.Sin(2.0*geomMeanLonSun*degToRad) -
		2.0*eccentEarthOrbit*math.Sin(geomMeanAnomSun*degToRad) +
		4.0*eccentEarthOrbit*y*math.Sin(geomMeanAnomSun*degToRad)*math.Cos(2.0*geomMeanLonSun*degToRad) -
		0.5*y*y*math.Sin(4.0*geomMeanLonSun*degToRad) -
		1.25*eccentEarthOrbit*eccentEarthOrbit*math.Sin(2.0*geomMeanAnomSun*degToRad))

	// True solar time (minutes)
	timeInMinutes := float64(ts.Hour())*60.0 + float64(ts.Minute()) + float64(ts.Second())/60.0
	trueSolarTime := math.Mod(timeInMinutes+eqOfTime+4.0*lon, 1440.0)

	// Hour angle (degrees)
	hourAngle := trueSolarTime/4.0 - 180.0
	if trueSolarTime < 0 {
		hourAngle = trueSolarTime/4.0 + 180.0
	}

	// Solar zenith angle (degrees)
	latRad := lat * degToRad
	decRad := declination * degToRad
	haRad := hourAngle * degToRad

	cosZenith := math.Sin(latRad)*math.Sin(decRad) +
		math.Cos(latRad)*math.Cos(decRad)*math.Cos(haRad)
	if cosZenith > 1.0 {
		cosZenith = 1.0
	}
	if cosZenith < -1.0 {
		cosZenith = -1.0
	}
	zenith := math.Acos(cosZenith) * radToDeg

	// Solar elevation angle (degrees)
	elevation := 90.0 - zenith

	// Atmospheric refraction correction
	if elevation > 85.0 {
		// No correction needed near zenith
	} else if elevation > 5.0 {
		refractionCorrection := 58.1/math.Tan(elevation*degToRad) -
			0.07/pow(math.Tan(elevation*degToRad), 3) +
			0.000086/pow(math.Tan(elevation*degToRad), 5)
		elevation += refractionCorrection / 3600.0
	} else if elevation > -0.575 {
		refractionCorrection := 1735.0 + elevation*(-518.2+elevation*(103.4+elevation*(-12.79+elevation*0.711)))
		elevation += refractionCorrection / 3600.0
	} else {
		refractionCorrection := -20.772 / math.Tan(elevation*degToRad)
		elevation += refractionCorrection / 3600.0
	}

	// Solar azimuth angle (degrees, clockwise from north)
	var azimuth float64
	if hourAngle > 0 {
		azimuth = math.Mod(
			math.Acos(
				(math.Sin(latRad)*cosZenith-math.Sin(decRad))/
					(math.Cos(latRad)*math.Sin(zenith*degToRad)),
			)*radToDeg+180.0,
			360.0,
		)
	} else {
		azimuth = math.Mod(
			540.0-math.Acos(
				(math.Sin(latRad)*cosZenith-math.Sin(decRad))/
					(math.Cos(latRad)*math.Sin(zenith*degToRad)),
			)*radToDeg,
			360.0,
		)
	}

	return domain.SunPosition{
		Azimuth:         azimuth,
		Elevation:       elevation,
		Zenith:          zenith,
		HourAngle:       hourAngle,
		SunRadiusVector: sunRadiusVector,
		Timestamp:       ts,
	}
}

// julianDay calculates the Julian Day Number for a given time.
func julianDay(t time.Time) float64 {
	y := float64(t.Year())
	m := float64(t.Month())
	d := float64(t.Day()) + float64(t.Hour())/24.0 +
		float64(t.Minute())/1440.0 + float64(t.Second())/86400.0

	if m <= 2 {
		y--
		m += 12
	}

	a := math.Floor(y / 100.0)
	b := 2 - a + math.Floor(a/4.0)

	return math.Floor(365.25*(y+4716)) + math.Floor(30.6001*(m+1)) + d + b - 1524.5
}

// sinDeg computes sin of an angle in degrees.
func sinDeg(deg float64) float64 {
	return math.Sin(deg * degToRad)
}

// pow computes base^exp using math.Pow.
func pow(base, exp float64) float64 {
	return math.Pow(base, exp)
}

