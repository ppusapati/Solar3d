package kafka

// Topic constants for all domain events in Brahma ERP.
//
// Naming convention: {module}.{entity}.{event}
//   - module:  bounded context (identity, sales, finance, etc.)
//   - entity:  aggregate or domain object
//   - event:   past-tense verb describing what happened
//
// All topics are pre-created at infrastructure startup via
// scripts/create-kafka-topics.sh. Auto-creation is disabled on the broker.
const (
	// -----------------------------------------------------------------------
	// Identity
	// -----------------------------------------------------------------------
	TopicUserCreated   = "identity.user.created"
	TopicUserUpdated   = "identity.user.updated"
	TopicTenantCreated = "identity.tenant.created"

	// -----------------------------------------------------------------------
	// Sales
	// -----------------------------------------------------------------------
	TopicSalesOrderCreated  = "sales.order.created"
	TopicSalesOrderApproved = "sales.order.approved"
	TopicSalesInvoiceCreated = "sales.invoice.created"

	// -----------------------------------------------------------------------
	// Purchase
	// -----------------------------------------------------------------------
	TopicPurchaseOrderCreated   = "purchase.order.created"
	TopicPurchaseInvoiceCreated = "purchase.invoice.created"

	// -----------------------------------------------------------------------
	// Inventory
	// -----------------------------------------------------------------------
	TopicStockTransferred = "inventory.stock.transferred"
	TopicStockAdjusted    = "inventory.stock.adjusted"

	// -----------------------------------------------------------------------
	// Finance
	// -----------------------------------------------------------------------
	TopicJournalEntryPosted = "finance.journal.posted"
	TopicPaymentProcessed   = "finance.payment.processed"
	TopicInvoicePaid        = "finance.invoice.paid"

	// -----------------------------------------------------------------------
	// HR
	// -----------------------------------------------------------------------
	TopicEmployeeOnboarded = "hr.employee.onboarded"
	TopicLeaveApproved     = "hr.leave.approved"
	TopicPayrollProcessed  = "hr.payroll.processed"

	// -----------------------------------------------------------------------
	// Manufacturing
	// -----------------------------------------------------------------------
	TopicProductionOrderCreated = "manufacturing.order.created"
	TopicProductionCompleted    = "manufacturing.production.completed"

	// -----------------------------------------------------------------------
	// Fulfillment
	// -----------------------------------------------------------------------
	TopicShipmentCreated  = "fulfillment.shipment.created"
	TopicShipmentDelivered = "fulfillment.shipment.delivered"
	TopicReturnRequested  = "fulfillment.return.requested"

	// -----------------------------------------------------------------------
	// Projects
	// -----------------------------------------------------------------------
	TopicProjectCreated = "projects.project.created"
	TopicTaskCompleted  = "projects.task.completed"

	// -----------------------------------------------------------------------
	// Workflow
	// -----------------------------------------------------------------------
	TopicApprovalRequested = "workflow.approval.requested"
	TopicApprovalCompleted = "workflow.approval.completed"

	// -----------------------------------------------------------------------
	// Asset
	// -----------------------------------------------------------------------
	TopicAssetRegistered      = "asset.registered"
	TopicMaintenanceScheduled = "asset.maintenance.scheduled"
)

// AllTopics returns every registered topic name. Used by the topic bootstrap
// script and integration tests to ensure all topics exist before the
// application starts producing messages.
func AllTopics() []string {
	return []string{
		// Identity
		TopicUserCreated, TopicUserUpdated, TopicTenantCreated,
		// Sales
		TopicSalesOrderCreated, TopicSalesOrderApproved, TopicSalesInvoiceCreated,
		// Purchase
		TopicPurchaseOrderCreated, TopicPurchaseInvoiceCreated,
		// Inventory
		TopicStockTransferred, TopicStockAdjusted,
		// Finance
		TopicJournalEntryPosted, TopicPaymentProcessed, TopicInvoicePaid,
		// HR
		TopicEmployeeOnboarded, TopicLeaveApproved, TopicPayrollProcessed,
		// Manufacturing
		TopicProductionOrderCreated, TopicProductionCompleted,
		// Fulfillment
		TopicShipmentCreated, TopicShipmentDelivered, TopicReturnRequested,
		// Projects
		TopicProjectCreated, TopicTaskCompleted,
		// Workflow
		TopicApprovalRequested, TopicApprovalCompleted,
		// Asset
		TopicAssetRegistered, TopicMaintenanceScheduled,
	}
}
