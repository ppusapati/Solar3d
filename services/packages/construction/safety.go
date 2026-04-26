package construction

import "time"

// ========================================================================
// JSA (Job Safety Analysis) Templates
// ========================================================================

// JSATemplate is a pre-built safety analysis for a specific construction activity.
type JSATemplate struct {
	ID          string    `json:"id"`
	ActivityName string   `json:"activity_name"`
	Steps       []JSAStep `json:"steps"`
}

// JSAStep is one step in a JSA with hazards and controls.
type JSAStep struct {
	StepNumber  int      `json:"step_number"`
	Description string   `json:"description"`
	Hazards     []string `json:"hazards"`
	Controls    []string `json:"controls"`
	PPERequired []string `json:"ppe_required"`
}

// DefaultJSATemplates returns the standard library for solar construction.
func DefaultJSATemplates() []JSATemplate {
	return []JSATemplate{
		{
			ID: "jsa-pile-driving", ActivityName: "Pile Driving",
			Steps: []JSAStep{
				{1, "Set up pile driver on trailer/skid", []string{"Struck-by equipment", "Pinch points"}, []string{"Exclusion zone around equipment", "Spotter during positioning"}, []string{"Hard hat", "Steel-toe boots", "High-vis vest"}},
				{2, "Position pile at marked location", []string{"Manual handling strain", "Struck-by falling pile"}, []string{"Use mechanical lifting aids", "Tag lines for control"}, []string{"Hard hat", "Gloves", "Steel-toe boots"}},
				{3, "Drive pile to required depth", []string{"Noise exposure >85 dBA", "Vibration", "Flying debris"}, []string{"Hearing protection mandatory", "Anti-vibration gloves", "Face shield"}, []string{"Hard hat", "Hearing protection", "Safety glasses", "Face shield"}},
				{4, "Verify embedment and plumb", []string{"Trip hazard from driven piles"}, []string{"Mark completed piles with flagging"}, []string{"Hard hat", "Steel-toe boots"}},
			},
		},
		{
			ID: "jsa-module-install", ActivityName: "Module Installation",
			Steps: []JSAStep{
				{1, "Unpack modules from pallets", []string{"Cuts from packaging", "Manual handling (20-35 kg)"}, []string{"Cut-resistant gloves", "Two-person lift for modules >25 kg"}, []string{"Gloves", "Steel-toe boots", "Safety glasses"}},
				{2, "Carry module to racking position", []string{"Wind gusts (module acts as sail)", "Slips/trips on uneven ground"}, []string{"Stop work if wind >40 km/h", "Maintain clear walking paths"}, []string{"Hard hat", "Gloves", "Steel-toe boots"}},
				{3, "Place module on clamps and secure", []string{"Pinch points at clamps", "Electrical shock (partial string energized)"}, []string{"De-energize string before connecting", "Insulated gloves for electrical work"}, []string{"Hard hat", "Gloves", "Insulated gloves (Class 0)"}},
				{4, "Connect MC4 connectors", []string{"Electrical arc if under load", "Connector damage"}, []string{"Verify string is open before connecting", "Check connector for damage before mating"}, []string{"Insulated gloves", "Safety glasses", "Arc-rated clothing"}},
			},
		},
		{
			ID: "jsa-electrical-termination", ActivityName: "Electrical Termination & Inverter Work",
			Steps: []JSAStep{
				{1, "Verify LOTO is in place", []string{"Electrical shock/arc flash"}, []string{"Follow LOTO procedure per OSHA 1910.147", "Verify zero energy state with meter"}, []string{"Arc-rated PPE per NFPA 70E", "Insulated gloves", "Face shield"}},
				{2, "Terminate conductors in combiner/inverter", []string{"Electrical shock", "Loose connections"}, []string{"Torque connections to manufacturer spec", "IR scan after energization"}, []string{"Insulated gloves", "Safety glasses"}},
				{3, "Energize and commission", []string{"Arc flash", "Unexpected back-feed"}, []string{"Wear PPE per arc-flash label", "Follow energization sequence"}, []string{"Arc-flash suit (PPE Cat per label)", "Insulated gloves", "Face shield"}},
			},
		},
	}
}

// ========================================================================
// Incident Record (OSHA 300/301)
// ========================================================================

// IncidentRecord stores an OSHA-reportable incident with fields matching
// OSHA Form 300 (Log of Work-Related Injuries) and Form 301 (Incident Report).
type IncidentRecord struct {
	ID                  string     `json:"id"`
	ProjectID           string     `json:"project_id"`
	IncidentDate        time.Time  `json:"incident_date"`
	ReportedAt          time.Time  `json:"reported_at"`
	EmployeeName        string     `json:"employee_name"`
	JobTitle            string     `json:"job_title"`
	Location            string     `json:"location"`           // specific area on site
	Description         string     `json:"description"`
	BodyPartAffected    string     `json:"body_part_affected"` // "hand", "back", "eye", etc.
	NatureOfInjury      string     `json:"nature_of_injury"`   // "laceration", "sprain", "burn", etc.
	Severity            string     `json:"severity"`           // "first_aid", "medical_treatment", "lost_time", "fatality"
	DaysAwayFromWork    int        `json:"days_away_from_work"`
	DaysRestrictedDuty  int        `json:"days_restricted_duty"`
	ObjectOrSubstance   string     `json:"object_or_substance"` // what caused the injury
	EventType           string     `json:"event_type"`          // "struck_by", "fall", "electrical", "heat", "caught_in"
	RootCause           string     `json:"root_cause"`
	CorrectiveAction    string     `json:"corrective_action"`
	WitnessNames        []string   `json:"witness_names,omitempty"`
	OSHARecordable      bool       `json:"osha_recordable"`
	OSHAFormNumber      string     `json:"osha_form_number"` // "300", "301", "300A"
	ReportedBy          string     `json:"reported_by"`
	InvestigatedBy      string     `json:"investigated_by,omitempty"`
	InvestigationClosedAt *time.Time `json:"investigation_closed_at,omitempty"`
}

// ========================================================================
// Toolbox Talk Log
// ========================================================================

// ToolboxTalk records a pre-shift safety briefing.
type ToolboxTalk struct {
	ID            string    `json:"id"`
	ProjectID     string    `json:"project_id"`
	Date          time.Time `json:"date"`
	Topic         string    `json:"topic"`
	Presenter     string    `json:"presenter"`
	DurationMin   int       `json:"duration_min"`
	Attendees     []string  `json:"attendees"`
	AttendeeCount int       `json:"attendee_count"`
	Notes         string    `json:"notes,omitempty"`
	SignatureURL  string    `json:"signature_url,omitempty"` // sign-in sheet photo
}
