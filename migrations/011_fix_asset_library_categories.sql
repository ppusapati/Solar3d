-- Fix asset library categories from uppercase to lowercase
-- This migration corrects the seed data from migration 010

DELETE FROM assets WHERE manufacturer IN ('JinkoSolar', 'Canadian Solar', 'Trina Solar', 'Fronius', 'SMA', 'SolarEdge', 'ABB', 'Huawei', 'Siemens', 'Eaton', 'Schneider Electric', 'IronRidge', 'Mounting Systems', 'Helical Piles', 'Soltec', 'Nextracker', 'GE', 'Lappkabel', 'Nexans');

-- Solar Panels
INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params) VALUES
('Hi-Perf 550W', 'JinkoSolar', 'JKM550M-72', 'panel', 2276, 1134, 35, 27.5, 
 '{"widthMm": 2276, "heightMm": 1134, "depthMm": 35}'::jsonb,
 '{"ratedPowerW": 550, "efficiency": 0.22, "voc": 48.2, "isc": 12.4, "temperatureCoefficient": -0.3}'::jsonb),
('Hi-Perf 600W', 'Canadian Solar', 'CS6R-600', 'panel', 2094, 1038, 40, 24.5,
 '{"widthMm": 2094, "heightMm": 1038, "depthMm": 40}'::jsonb,
 '{"ratedPowerW": 600, "efficiency": 0.225, "voc": 49.2, "isc": 13.2, "temperatureCoefficient": -0.32}'::jsonb),
('Performance 500W', 'Trina Solar', 'TSM-500DE19', 'panel', 2278, 1134, 40, 22.5,
 '{"widthMm": 2278, "heightMm": 1134, "depthMm": 40}'::jsonb,
 '{"ratedPowerW": 500, "efficiency": 0.215, "voc": 49.5, "isc": 12.1, "temperatureCoefficient": -0.31}'::jsonb);

-- String Inverters (1-6 kW)
INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params) VALUES
('String Inv 3.3kW', 'Fronius', 'Primo 3.3 WLAN', 'inverter', 580, 770, 200, 28.5,
 '{"widthMm": 580, "heightMm": 770, "depthMm": 200}'::jsonb,
 '{"ratedPowerW": 3300, "efficiency": 0.97, "inputVtgRungeMin": 70, "inputVtgRangeMax": 500, "dcInputLimit": 10}'::jsonb),
('String Inv 4.6kW', 'SMA', 'Sunny Boy 4.6-US', 'inverter', 700, 450, 140, 24.0,
 '{"widthMm": 700, "heightMm": 450, "depthMm": 140}'::jsonb,
 '{"ratedPowerW": 4600, "efficiency": 0.975, "inputVtgRungeMin": 80, "inputVtgRangeMax": 500, "dcInputLimit": 12.5}'::jsonb),
('String Inv 5.5kW', 'SolarEdge', 'SE5K-US', 'inverter', 660, 540, 180, 32.0,
 '{"widthMm": 660, "heightMm": 540, "depthMm": 180}'::jsonb,
 '{"ratedPowerW": 5500, "efficiency": 0.97, "inputVtgRungeMin": 100, "inputVtgRangeMax": 500, "dcInputLimit": 13}'::jsonb);

-- Central Inverters (25-50 kW)
INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params) VALUES
('Central Inv 25kW', 'ABB', 'PVS980-25', 'inverter', 1200, 2000, 600, 180.0,
 '{"widthMm": 1200, "heightMm": 2000, "depthMm": 600}'::jsonb,
 '{"ratedPowerW": 25000, "efficiency": 0.988, "inputVtgRungeMin": 200, "inputVtgRangeMax": 700, "dcInputLimit": 50}'::jsonb),
('Central Inv 36kW', 'Huawei', 'SUN2000-36KTL-INV', 'inverter', 1200, 1800, 500, 155.0,
 '{"widthMm": 1200, "heightMm": 1800, "depthMm": 500}'::jsonb,
 '{"ratedPowerW": 36000, "efficiency": 0.989, "inputVtgRungeMin": 200, "inputVtgRangeMax": 700, "dcInputLimit": 65}'::jsonb),
('Central Inv 50kW', 'Siemens', 'SINVERT PVS 50U', 'inverter', 1300, 2000, 600, 210.0,
 '{"widthMm": 1300, "heightMm": 2000, "depthMm": 600}'::jsonb,
 '{"ratedPowerW": 50000, "efficiency": 0.989, "inputVtgRungeMin": 200, "inputVtgRangeMax": 700, "dcInputLimit": 80}'::jsonb);

-- Mounting Structures
INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params) VALUES
('Roof Mount Kit', 'IronRidge', 'XR Rail', 'mounting', 4000, 50, 50, 4.5,
 '{"widthMm": 4000, "heightMm": 50, "depthMm": 50}'::jsonb,
 '{"loadCapacityKg": 200, "materialAluminum": true}'::jsonb),
('Ground Mount Fixed', 'Mounting Systems', 'MS-GF-4', 'mounting', 2500, 1500, 800, 85.0,
 '{"widthMm": 2500, "heightMm": 1500, "depthMm": 800}'::jsonb,
 '{"loadCapacityKg": 500, "tiltAngleDeg": 25, "systemType": "fixed"}'::jsonb),
('Foundation Pile', 'Helical Piles', 'HP-3x8', 'mounting', 300, 300, 8000, 350.0,
 '{"widthMm": 300, "heightMm": 300, "depthMm": 8000}'::jsonb,
 '{"depthMm": 8000, "bearingCapacityKg": 5000}'::jsonb);

-- Trackers (1-3 axis)
INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params) VALUES
('Dual Axis Tracker', 'Soltec', 'SF7X1.5', 'tracker', 7500, 1500, 500, 250.0,
 '{"widthMm": 7500, "heightMm": 1500, "depthMm": 500}'::jsonb,
 '{"panelCapacity": 40, "typeAxisCount": 2, "motorPowerW": 1500}'::jsonb),
('Single Axis Horizontal', 'Nextracker', 'NX Horizon', 'tracker', 15000, 1500, 400, 150.0,
 '{"widthMm": 15000, "heightMm": 1500, "depthMm": 400}'::jsonb,
 '{"panelCapacity": 80, "typeAxisCount": 1, "motorPowerW": 750}'::jsonb);

-- Transformers (100-500 kVA)
INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params) VALUES
('Oil Transformer 100kVA', 'GE', 'JEC-100', 'transformer', 1200, 1200, 1200, 2800.0,
 '{"widthMm": 1200, "heightMm": 1200, "depthMm": 1200}'::jsonb,
 '{"ratedPowerKva": 100, "primaryVoltageV": 480, "secondaryVoltageV": 20000, "efficiency": 0.985}'::jsonb),
('Oil Transformer 250kVA', 'ABB', 'DOLT-250', 'transformer', 1500, 1500, 1400, 6500.0,
 '{"widthMm": 1500, "heightMm": 1500, "depthMm": 1400}'::jsonb,
 '{"ratedPowerKva": 250, "primaryVoltageV": 480, "secondaryVoltageV": 20000, "efficiency": 0.986}'::jsonb),
('Oil Transformer 500kVA', 'Siemens', 'TRAFO-500', 'transformer', 2000, 2000, 1500, 15000.0,
 '{"widthMm": 2000, "heightMm": 2000, "depthMm": 1500}'::jsonb,
 '{"ratedPowerKva": 500, "primaryVoltageV": 480, "secondaryVoltageV": 34500, "efficiency": 0.987}'::jsonb);

-- Combiner Boxes
INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params) VALUES
('DC Combiner 12-String', 'Eaton', 'XVI-12', 'other', 600, 800, 250, 35.0,
 '{"widthMm": 600, "heightMm": 800, "depthMm": 250}'::jsonb,
 '{"inputStrings": 12, "outputCircuits": 1, "maxInputCurrentA": 180, "maxOutputCurrentA": 180}'::jsonb),
('AC Combiner 4-Way', 'Schneider Electric', 'CombiBox 4', 'other', 800, 600, 300, 40.0,
 '{"widthMm": 800, "heightMm": 600, "depthMm": 300}'::jsonb,
 '{"inputCircuits": 4, "outputCircuits": 1, "maxInputCurrentA": 32, "maxOutputCurrentA": 32}'::jsonb);

-- Cables
INSERT INTO assets (name, manufacturer, model, category, width_mm, height_mm, depth_mm, weight_kg, dimensions, electrical_params) VALUES
('PV Cable 6mm2', 'Lappkabel', 'ÖLFLEX SOLAR', 'cable', 8, 8, 1000, 4.5,
 '{"diameterMm": 8, "lengthM": 1000}'::jsonb,
 '{"crossSectionMm2": 6, "ratedVoltageV": 1000, "maxCurrentA": 56, "resistancePerKmOhm": 3.08}'::jsonb),
('PV Cable 10mm2', 'Nexans', 'N2xy', 'cable', 10, 10, 1000, 8.5,
 '{"diameterMm": 10, "lengthM": 1000}'::jsonb,
 '{"crossSectionMm2": 10, "ratedVoltageV": 1000, "maxCurrentA": 80, "resistancePerKmOhm": 1.91}'::jsonb),
('AC Cable 16mm2', 'Siemens', 'N25X', 'cable', 12, 12, 1000, 15.0,
 '{"diameterMm": 12, "lengthM": 1000}'::jsonb,
 '{"crossSectionMm2": 16, "ratedVoltageV": 450, "maxCurrentA": 110, "resistancePerKmOhm": 1.15}'::jsonb);
