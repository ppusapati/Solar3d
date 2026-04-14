package service

import (
	"context"
	"testing"

	"github.com/google/uuid"

	"solar3d/electrical-service/internal/domain"
)

type stubElectricalRepository struct {
	network              *domain.ElectricalNetwork
	stringsByID          map[uuid.UUID]domain.PanelString
	stringsByNetwork     []domain.PanelString
	inverterGroups       []domain.InverterGroup
	createdString        *domain.PanelString
	createdInverterGroup *domain.InverterGroup
	assignedInverterID   uuid.UUID
	assignedStringIDs    []uuid.UUID
	updatedNetwork       *domain.ElectricalNetwork
	inverterACOutputKW   float64
	createStringCalls    int
	createInverterCalls  int
	assignStringsCalls   int
	updateNetworkCalls   int
}

func (r *stubElectricalRepository) CreateNetwork(context.Context, *domain.ElectricalNetwork) error {
	panic("unexpected CreateNetwork call")
}

func (r *stubElectricalRepository) GetNetworkByID(context.Context, uuid.UUID) (*domain.ElectricalNetwork, error) {
	return cloneNetwork(r.network), nil
}

func (r *stubElectricalRepository) ListNetworksByProject(context.Context, uuid.UUID) ([]domain.ElectricalNetwork, error) {
	panic("unexpected ListNetworksByProject call")
}

func (r *stubElectricalRepository) UpdateNetwork(_ context.Context, net *domain.ElectricalNetwork) error {
	r.updateNetworkCalls++
	r.updatedNetwork = cloneNetwork(net)
	return nil
}

func (r *stubElectricalRepository) DeleteNetwork(context.Context, uuid.UUID) error {
	panic("unexpected DeleteNetwork call")
}

func (r *stubElectricalRepository) CreateString(_ context.Context, ps *domain.PanelString) error {
	r.createStringCalls++
	r.createdString = clonePanelString(ps)
	r.stringsByID[ps.ID] = *clonePanelString(ps)
	r.stringsByNetwork = append(r.stringsByNetwork, *clonePanelString(ps))
	return nil
}

func (r *stubElectricalRepository) ListStringsByNetwork(context.Context, uuid.UUID) ([]domain.PanelString, error) {
	return append([]domain.PanelString(nil), r.stringsByNetwork...), nil
}

func (r *stubElectricalRepository) ListStringsByIDs(_ context.Context, _ uuid.UUID, stringIDs []uuid.UUID) ([]domain.PanelString, error) {
	strings := make([]domain.PanelString, 0, len(stringIDs))
	for _, stringID := range stringIDs {
		panelString, ok := r.stringsByID[stringID]
		if !ok {
			continue
		}
		strings = append(strings, panelString)
	}
	return strings, nil
}

func (r *stubElectricalRepository) CreateInverterGroup(_ context.Context, ig *domain.InverterGroup) error {
	r.createInverterCalls++
	r.createdInverterGroup = cloneInverterGroup(ig)
	r.inverterGroups = append(r.inverterGroups, *cloneInverterGroup(ig))
	return nil
}

func (r *stubElectricalRepository) ListInverterGroupsByNetwork(context.Context, uuid.UUID) ([]domain.InverterGroup, error) {
	return append([]domain.InverterGroup(nil), r.inverterGroups...), nil
}

func (r *stubElectricalRepository) AssignStringsToInverterGroup(_ context.Context, _ uuid.UUID, inverterGroupID uuid.UUID, stringIDs []uuid.UUID) error {
	r.assignStringsCalls++
	r.assignedInverterID = inverterGroupID
	r.assignedStringIDs = append([]uuid.UUID(nil), stringIDs...)
	for index := range r.stringsByNetwork {
		for _, stringID := range stringIDs {
			if r.stringsByNetwork[index].ID == stringID {
				r.stringsByNetwork[index].InverterGroupID = inverterGroupID
			}
		}
	}
	for _, stringID := range stringIDs {
		panelString := r.stringsByID[stringID]
		panelString.InverterGroupID = inverterGroupID
		if r.stringsByID == nil {
			r.stringsByID = map[uuid.UUID]domain.PanelString{}
		}
		if panelString.ID != uuid.Nil {
			r.stringsByID[stringID] = panelString
		}
	}
	return nil
}

func (r *stubElectricalRepository) GetInverterACOutputKW(context.Context, uuid.UUID) (float64, error) {
	return r.inverterACOutputKW, nil
}

func TestCreateStringUpdatesNetworkSummary(t *testing.T) {
	networkID := uuid.New()
	repo := &stubElectricalRepository{
		network:     &domain.ElectricalNetwork{ID: networkID},
		stringsByID: map[uuid.UUID]domain.PanelString{},
	}
	svc := &ElectricalService{repo: repo}

	panelIDs := []uuid.UUID{uuid.New(), uuid.New(), uuid.New()}
	created, err := svc.CreateString(context.Background(), domain.CreateStringRequest{
		NetworkID: networkID,
		PanelIDs:  panelIDs,
		Voltage:   48,
		Current:   10,
	})
	if err != nil {
		t.Fatalf("CreateString returned error: %v", err)
	}
	if created.InverterGroupID != uuid.Nil {
		t.Fatalf("expected unassigned string to keep empty inverter group, got %s", created.InverterGroupID)
	}
	if repo.createStringCalls != 1 {
		t.Fatalf("expected CreateString to be called once, got %d", repo.createStringCalls)
	}
	if repo.updateNetworkCalls != 1 {
		t.Fatalf("expected UpdateNetwork to be called once, got %d", repo.updateNetworkCalls)
	}
	if repo.updatedNetwork == nil {
		t.Fatal("expected network summary to be updated")
	}
	if repo.updatedNetwork.StringCount != 1 {
		t.Fatalf("expected StringCount=1, got %d", repo.updatedNetwork.StringCount)
	}
	expectedDCKW := 48.0 * float64(len(panelIDs)) * 10.0 / 1000.0
	if repo.updatedNetwork.TotalDCCapacityKW != expectedDCKW {
		t.Fatalf("expected TotalDCCapacityKW=%v, got %v", expectedDCKW, repo.updatedNetwork.TotalDCCapacityKW)
	}
	if repo.updatedNetwork.InverterCount != 0 {
		t.Fatalf("expected InverterCount=0, got %d", repo.updatedNetwork.InverterCount)
	}
	if repo.updatedNetwork.TotalACCapacityKW != 0 {
		t.Fatalf("expected TotalACCapacityKW=0, got %v", repo.updatedNetwork.TotalACCapacityKW)
	}
}

func TestAssignInverterUpdatesAssignmentsAndSummary(t *testing.T) {
	networkID := uuid.New()
	stringA := domain.PanelString{ID: uuid.New(), NetworkID: networkID, PowerW: 6000}
	stringB := domain.PanelString{ID: uuid.New(), NetworkID: networkID, PowerW: 4000}
	repo := &stubElectricalRepository{
		network:            &domain.ElectricalNetwork{ID: networkID},
		stringsByID:        map[uuid.UUID]domain.PanelString{stringA.ID: stringA, stringB.ID: stringB},
		stringsByNetwork:   []domain.PanelString{stringA, stringB},
		inverterACOutputKW: 8,
	}
	svc := &ElectricalService{repo: repo}

	group, err := svc.AssignInverter(context.Background(), domain.AssignInverterRequest{
		NetworkID:       networkID,
		InverterAssetID: uuid.New(),
		StringIDs:       []uuid.UUID{stringA.ID, stringB.ID},
		Position:        [2]float64{12.5, 24.5},
	})
	if err != nil {
		t.Fatalf("AssignInverter returned error: %v", err)
	}
	if repo.createInverterCalls != 1 {
		t.Fatalf("expected CreateInverterGroup to be called once, got %d", repo.createInverterCalls)
	}
	if repo.assignStringsCalls != 1 {
		t.Fatalf("expected AssignStringsToInverterGroup to be called once, got %d", repo.assignStringsCalls)
	}
	if repo.updatedNetwork == nil {
		t.Fatal("expected network summary to be updated")
	}
	if group.DCInputKW != 10 {
		t.Fatalf("expected DCInputKW=10, got %v", group.DCInputKW)
	}
	if group.ACOutputKW != 8 {
		t.Fatalf("expected ACOutputKW=8, got %v", group.ACOutputKW)
	}
	if group.DCACRatio != 1.25 {
		t.Fatalf("expected DCACRatio=1.25, got %v", group.DCACRatio)
	}
	if repo.updatedNetwork.StringCount != 2 {
		t.Fatalf("expected StringCount=2, got %d", repo.updatedNetwork.StringCount)
	}
	if repo.updatedNetwork.InverterCount != 1 {
		t.Fatalf("expected InverterCount=1, got %d", repo.updatedNetwork.InverterCount)
	}
	if repo.updatedNetwork.TotalDCCapacityKW != 10 {
		t.Fatalf("expected TotalDCCapacityKW=10, got %v", repo.updatedNetwork.TotalDCCapacityKW)
	}
	if repo.updatedNetwork.TotalACCapacityKW != 8 {
		t.Fatalf("expected TotalACCapacityKW=8, got %v", repo.updatedNetwork.TotalACCapacityKW)
	}
	if repo.updatedNetwork.DCACRatio != 1.25 {
		t.Fatalf("expected network DCACRatio=1.25, got %v", repo.updatedNetwork.DCACRatio)
	}
	if repo.assignedInverterID != group.ID {
		t.Fatalf("expected strings to be assigned to created group %s, got %s", group.ID, repo.assignedInverterID)
	}
}

func cloneNetwork(net *domain.ElectricalNetwork) *domain.ElectricalNetwork {
	if net == nil {
		return nil
	}
	clone := *net
	return &clone
}

func clonePanelString(ps *domain.PanelString) *domain.PanelString {
	if ps == nil {
		return nil
	}
	clone := *ps
	clone.PanelIDs = append([]uuid.UUID(nil), ps.PanelIDs...)
	return &clone
}

func cloneInverterGroup(ig *domain.InverterGroup) *domain.InverterGroup {
	if ig == nil {
		return nil
	}
	clone := *ig
	clone.StringIDs = append([]uuid.UUID(nil), ig.StringIDs...)
	return &clone
}

