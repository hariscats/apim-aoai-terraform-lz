// Marketplace Offer Subscription
resource "azapi_resource" "marketplace_subscription" {
  type      = "Microsoft.MachineLearningServices/workspaces/marketplaceSubscriptions@2024-04-01-preview"
  name      = "${var.environment_name}-${var.model.name}"
  parent_id = azapi_resource.ai_project.id

  body = jsonencode({
    properties = {
      modelId = var.model.id
      marketplacePlan = {
        publisherId = var.model.marketplace_publisher_id
        offerId     = var.model.marketplace_offer_id
        planId      = var.model.marketplace_plan_id
      }
    }
  })

  schema_validation_enabled = false
  tags                      = var.tags
}

// Example: Serverless Endpoint for Cohere ReRank Model
resource "azapi_resource" "cohere_serverless_endpoint" {
  type      = "Microsoft.MachineLearningServices/workspaces/serverlessEndpoints@2024-04-01-preview"
  name      = "se-${var.environment_name}-${var.model.name}"
  location  = var.location
  parent_id = azapi_resource.ai_project.id

  identity {
    type = "SystemAssigned"
  }

  body = jsonencode({
    sku = {
      name = "Consumption"
    }
    properties = {
      modelSettings = {
        modelId = var.model.id
      }
      marketplaceSubscriptionId = azapi_resource.marketplace_subscription.id
    }
  })

  schema_validation_enabled = false
}
