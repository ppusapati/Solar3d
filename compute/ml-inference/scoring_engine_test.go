package ml_inference

import "testing"

func TestScoringEngine_ScoreCandidate_Monotonicity(t *testing.T) {
	engine := NewScoringEngine(2.0, 10000.0, NewHardConstraintSet(), NewSoftConstraintSet(nil))

	lowCap := &CandidateArtifactGraph{
		LayoutID:  "layout-low",
		ProjectID: "project-1",
		SolarPanels: []*SolarPanel{
			{PanelID: "p1", MppCapacityKw: 400},
			{PanelID: "p2", MppCapacityKw: 400},
		},
		InverterGroups: []*InverterGroup{{InverterGroupID: "inv-1", DcAcRatio: 1.2, AcOutputKw: 1000, DcInputKw: 1200}},
		TransformerNodes: []*TransformerNode{{
			TransformerID:             "tx-1",
			KvaRating:                 2500,
			LoadKva:                   1000,
			ConnectedInverterGroupIDs: []string{"inv-1"},
		}},
		PanelStrings: []*PanelString{{StringID: "s1", StringVoltageVdc: 600, PanelIDs: []string{"p1"}}, {StringID: "s2", StringVoltageVdc: 600, PanelIDs: []string{"p2"}}},
	}

	highCap := &CandidateArtifactGraph{
		LayoutID:  "layout-high",
		ProjectID: "project-1",
		SolarPanels: []*SolarPanel{
			{PanelID: "p1", MppCapacityKw: 400},
			{PanelID: "p2", MppCapacityKw: 400},
			{PanelID: "p3", MppCapacityKw: 400},
			{PanelID: "p4", MppCapacityKw: 400},
		},
		InverterGroups: []*InverterGroup{{InverterGroupID: "inv-1", DcAcRatio: 1.2, AcOutputKw: 1000, DcInputKw: 1200}},
		TransformerNodes: []*TransformerNode{{
			TransformerID:             "tx-1",
			KvaRating:                 2500,
			LoadKva:                   1000,
			ConnectedInverterGroupIDs: []string{"inv-1"},
		}},
		PanelStrings: []*PanelString{
			{StringID: "s1", StringVoltageVdc: 600, PanelIDs: []string{"p1"}},
			{StringID: "s2", StringVoltageVdc: 600, PanelIDs: []string{"p2"}},
			{StringID: "s3", StringVoltageVdc: 600, PanelIDs: []string{"p3"}},
			{StringID: "s4", StringVoltageVdc: 600, PanelIDs: []string{"p4"}},
		},
	}

	lowScore, err := engine.ScoreCandidate(lowCap)
	if err != nil {
		t.Fatalf("low score failed: %v", err)
	}
	highScore, err := engine.ScoreCandidate(highCap)
	if err != nil {
		t.Fatalf("high score failed: %v", err)
	}

	if highScore.MwFitScore < lowScore.MwFitScore {
		t.Fatalf("expected higher capacity graph to have >= mw fit score")
	}
}

func TestScoringEngine_RankCandidates_Deterministic(t *testing.T) {
	engine := NewScoringEngine(1.0, 5000.0, NewHardConstraintSet(), NewSoftConstraintSet(nil))

	c1 := &CandidateArtifactGraph{
		LayoutID:     "layout-a",
		ProjectID:    "project-x",
		SolarPanels:  []*SolarPanel{{PanelID: "p1", MppCapacityKw: 500}},
		PanelStrings: []*PanelString{{StringID: "s1", StringVoltageVdc: 600, PanelIDs: []string{"p1"}}},
		InverterGroups: []*InverterGroup{{
			InverterGroupID: "inv-1",
			DcAcRatio:       1.2,
			DcInputKw:       1200,
			AcOutputKw:      1000,
		}},
		TransformerNodes: []*TransformerNode{{
			TransformerID:             "tx-1",
			KvaRating:                 2500,
			LoadKva:                   1000,
			ConnectedInverterGroupIDs: []string{"inv-1"},
		}},
	}

	c2 := &CandidateArtifactGraph{
		LayoutID:     "layout-b",
		ProjectID:    "project-x",
		SolarPanels:  []*SolarPanel{{PanelID: "p2", MppCapacityKw: 600}},
		PanelStrings: []*PanelString{{StringID: "s2", StringVoltageVdc: 600, PanelIDs: []string{"p2"}}},
		InverterGroups: []*InverterGroup{{
			InverterGroupID: "inv-2",
			DcAcRatio:       1.2,
			DcInputKw:       1200,
			AcOutputKw:      1000,
		}},
		TransformerNodes: []*TransformerNode{{
			TransformerID:             "tx-2",
			KvaRating:                 2500,
			LoadKva:                   1000,
			ConnectedInverterGroupIDs: []string{"inv-2"},
		}},
	}

	ranked1, err := engine.RankCandidates([]*CandidateArtifactGraph{c1, c2})
	if err != nil {
		t.Fatalf("ranked1 failed: %v", err)
	}
	ranked2, err := engine.RankCandidates([]*CandidateArtifactGraph{c1, c2})
	if err != nil {
		t.Fatalf("ranked2 failed: %v", err)
	}

	if len(ranked1) != 2 || len(ranked2) != 2 {
		t.Fatalf("expected 2 ranked candidates")
	}

	if ranked1[0].CandidateID != ranked2[0].CandidateID || ranked1[1].CandidateID != ranked2[1].CandidateID {
		t.Fatalf("deterministic ranking order mismatch")
	}

	if ranked1[0].Rank != 1 || ranked1[1].Rank != 2 {
		t.Fatalf("unexpected rank numbers: %d, %d", ranked1[0].Rank, ranked1[1].Rank)
	}
}

func TestScoringEngine_RankCandidates_ErrorOnEmpty(t *testing.T) {
	engine := NewScoringEngine(1.0, 5000.0, NewHardConstraintSet(), NewSoftConstraintSet(nil))
	if _, err := engine.RankCandidates(nil); err == nil {
		t.Fatalf("expected error for empty candidate list")
	}
}
