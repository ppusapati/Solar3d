package mappers

import (
	"solar3d/compute-service/internal/models"

	optimizationv1 "github.com/solar3d/solar3d/gen/optimization/v1"
)

func ProtoToParetoFrontier(req *optimizationv1.AddToFrontierRequest) *models.ParetoFrontierRequest {
	if req == nil || req.NewSolution == nil {
		return nil
	}

	objectives := make([]models.ObjectiveModel, 0, len(req.Objectives))
	for _, o := range req.Objectives {
		kind := "MINIMIZE"
		if o.Kind == optimizationv1.Objective_MAXIMIZE {
			kind = "MAXIMIZE"
		}
		objectives = append(objectives, models.ObjectiveModel{
			Name:   o.Name,
			Kind:   kind,
			Weight: o.Weight,
		})
	}

	return &models.ParetoFrontierRequest{
		Objectives: objectives,
		NewSolution: models.SolutionModel{
			ID:               req.NewSolution.Id,
			Variables:        append([]float64(nil), req.NewSolution.Variables...),
			Objectives:       append([]float64(nil), req.NewSolution.Objectives...),
			Rank:             req.NewSolution.Rank,
			CrowdingDistance: req.NewSolution.CrowdingDistance,
		},
	}
}

func ParetoFrontierToProto(resp *models.ParetoFrontierResponse) *optimizationv1.ParetoFrontierResponse {
	if resp == nil {
		return &optimizationv1.ParetoFrontierResponse{}
	}

	solutions := make([]*optimizationv1.Solution, 0, len(resp.Solutions))
	for _, s := range resp.Solutions {
		solutions = append(solutions, &optimizationv1.Solution{
			Id:               s.ID,
			Variables:        append([]float64(nil), s.Variables...),
			Objectives:       append([]float64(nil), s.Objectives...),
			Rank:             s.Rank,
			CrowdingDistance: s.CrowdingDistance,
		})
	}

	return &optimizationv1.ParetoFrontierResponse{
		Solutions:    solutions,
		FrontierSize: resp.FrontierSize,
		SolutionIds:  append([]int32(nil), resp.SolutionIDs...),
	}
}

func ProtoToMonteCarlo(req *optimizationv1.MonteCarloRequest) *models.MonteCarloRequest {
	if req == nil {
		return nil
	}
	dists := make([]models.DistributionModel, 0, len(req.Distributions))
	for _, d := range req.Distributions {
		dists = append(dists, models.DistributionModel{Mean: d.Mean, StdDev: d.StdDev})
	}
	return &models.MonteCarloRequest{Distributions: dists, NumSamples: req.NumSamples, Seed: req.Seed}
}

func MonteCarloToProto(resp *models.MonteCarloResponse) *optimizationv1.MonteCarloResponse {
	if resp == nil {
		return &optimizationv1.MonteCarloResponse{}
	}
	return &optimizationv1.MonteCarloResponse{
		Mean:     resp.Mean,
		StdDev:   resp.StdDev,
		P10:      resp.P10,
		P50:      resp.P50,
		P90:      resp.P90,
		MinValue: resp.MinValue,
		MaxValue: resp.MaxValue,
	}
}

func ProtoToGA(req *optimizationv1.GARequest) *models.GARequest {
	if req == nil {
		return nil
	}
	return &models.GARequest{
		PopulationSize:    req.PopulationSize,
		Generations:       req.Generations,
		CrossoverRate:     req.CrossoverRate,
		MutationRate:      req.MutationRate,
		EliteCount:        req.EliteCount,
		Seed:              req.Seed,
		InitialPopulation: append([]float64(nil), req.InitialPopulation...),
	}
}

func GAToProto(resp *models.GAResponse) *optimizationv1.GAResponse {
	if resp == nil {
		return &optimizationv1.GAResponse{}
	}
	return &optimizationv1.GAResponse{
		BestFitness:          resp.BestFitness,
		BestGenes:            append([]float64(nil), resp.BestGenes...),
		GenerationsCompleted: resp.GenerationsCompleted,
	}
}

func ProtoToSA(req *optimizationv1.SARequest) *models.SARequest {
	if req == nil {
		return nil
	}
	return &models.SARequest{
		InitialTemperature: req.InitialTemperature,
		CoolingRate:        req.CoolingRate,
		Iterations:         req.Iterations,
		PerturbationScale:  req.PerturbationScale,
		Seed:               req.Seed,
		InitialSolution:    append([]float64(nil), req.InitialSolution...),
	}
}

func SAToProto(resp *models.SAResponse) *optimizationv1.SAResponse {
	if resp == nil {
		return &optimizationv1.SAResponse{}
	}
	return &optimizationv1.SAResponse{
		BestEnergy:       resp.BestEnergy,
		BestSolution:     append([]float64(nil), resp.BestSolution...),
		FinalTemperature: resp.FinalTemperature,
	}
}

func ProtoToPSO(req *optimizationv1.PSORequest) *models.PSORequest {
	if req == nil {
		return nil
	}
	return &models.PSORequest{
		NumParticles: req.NumParticles,
		Iterations:   req.Iterations,
		C1:           req.C1,
		C2:           req.C2,
		W:            req.W,
		BoundaryMin:  req.BoundaryMin,
		BoundaryMax:  req.BoundaryMax,
		Seed:         req.Seed,
	}
}

func PSOToProto(resp *models.PSOResponse) *optimizationv1.PSOResponse {
	if resp == nil {
		return &optimizationv1.PSOResponse{}
	}
	return &optimizationv1.PSOResponse{
		BestPosition:        resp.BestPosition,
		BestValue:           resp.BestValue,
		IterationsCompleted: resp.IterationsCompleted,
	}
}

