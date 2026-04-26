// Package executor implements step execution for saga orchestration
package executor

import (
	"context"
	"fmt"
	"time"

	"p9e.in/samavaya/packages/saga"
	"p9e.in/samavaya/packages/saga/models"
)

// StepExecutorImpl executes individual saga steps via RPC.
//
// `logRepo` is consulted by GetStepStatus so callers (compensation engine,
// observability) can replay the saga timeline without a separate query path.
// It may be nil at construction time — in which case GetStepStatus returns
// an error that distinguishes "no log wired" from "step not found".
type StepExecutorImpl struct {
	rpcConnector saga.RpcConnector
	idempotency  *IdempotencyImpl
	logRepo      saga.SagaExecutionLogRepository
}

// NewStepExecutorImpl creates a new step executor instance.
func NewStepExecutorImpl(
	rpcConnector saga.RpcConnector,
	idempotency *IdempotencyImpl,
) *StepExecutorImpl {
	return &StepExecutorImpl{
		rpcConnector: rpcConnector,
		idempotency:  idempotency,
	}
}

// WithExecutionLog wires the step-execution log repository so GetStepStatus
// can serve queries. Returns the executor for fluent construction.
func (e *StepExecutorImpl) WithExecutionLog(repo saga.SagaExecutionLogRepository) *StepExecutorImpl {
	e.logRepo = repo
	return e
}

// ExecuteStep executes a single saga step via RPC invocation
func (e *StepExecutorImpl) ExecuteStep(
	ctx context.Context,
	sagaID string,
	stepNum int,
	stepDef *saga.StepDefinition,
) (*models.StepResult, error) {
	// 1. Check if result is cached (idempotent)
	cachedResult := e.idempotency.GetCachedResult(sagaID, stepNum)
	if cachedResult != nil {
		return cachedResult, nil
	}

	// 2. Resolve service endpoint
	endpoint, err := e.rpcConnector.GetServiceEndpoint(stepDef.ServiceName)
	if err != nil {
		return nil, fmt.Errorf("failed to resolve service endpoint: %w", err)
	}

	// 3. Build request from step definition
	request := buildStepRequest(stepDef)

	// 4. Track execution time
	startTime := time.Now()

	// 5. Invoke service via RPC
	response, err := e.rpcConnector.InvokeHandler(
		ctx,
		endpoint,
		stepDef.HandlerMethod,
		request,
	)

	executionTime := time.Since(startTime)

	// 6. Handle execution errors
	if err != nil {
		return nil, fmt.Errorf("RPC invocation failed for step %d: %w", stepNum, err)
	}

	// 7. Build result
	result := &models.StepResult{
		StepNumber:      int32(stepNum),
		Status:          models.StepStatusSucceeded,
		Result:          response,
		ExecutionTimeMs: executionTime.Milliseconds(),
		RetryCount:      0,
		CompletedAt:     time.Now(),
	}

	// 8. Cache result for idempotency
	if err := e.idempotency.CacheResult(sagaID, stepNum, result); err != nil {
		// Log but don't fail - caching is for optimization
		fmt.Printf("failed to cache step result: %v\n", err)
	}

	return result, nil
}

// GetStepStatus retrieves the status of a previously executed step. Returns
// the most recent execution record for the (sagaID, stepNum) pair — sagas
// that retry will have multiple records; the latest reflects current state.
func (e *StepExecutorImpl) GetStepStatus(
	ctx context.Context,
	sagaID string,
	stepNum int,
) (*models.StepExecution, error) {
	if e.logRepo == nil {
		return nil, fmt.Errorf("step executor: execution log repository not wired (call WithExecutionLog at construction)")
	}
	entries, err := e.logRepo.GetBySagaID(ctx, sagaID)
	if err != nil {
		return nil, fmt.Errorf("step executor: load execution log for saga %s: %w", sagaID, err)
	}
	var latest *models.StepExecution
	for _, entry := range entries {
		if entry == nil || int(entry.StepNumber) != stepNum {
			continue
		}
		if latest == nil || (entry.UpdatedAt != nil && (latest.UpdatedAt == nil || entry.UpdatedAt.After(*latest.UpdatedAt))) {
			latest = entry
		}
	}
	if latest == nil {
		return nil, fmt.Errorf("step executor: no execution record for saga %s step %d", sagaID, stepNum)
	}
	return latest, nil
}

// Helper function to build request from step definition
func buildStepRequest(stepDef *saga.StepDefinition) interface{} {
	// Build request based on step definition's InputMapping
	// This would typically deserialize the input mapping to the correct type
	request := map[string]interface{}{
		"stepNumber":   stepDef.StepNumber,
		"serviceName":  stepDef.ServiceName,
		"handlerMethod": stepDef.HandlerMethod,
	}

	// Add any input mapping from step definition
	if stepDef.InputMapping != nil {
		for key, value := range stepDef.InputMapping {
			request[key] = value
		}
	}

	return request
}
