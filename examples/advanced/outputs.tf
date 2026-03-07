output "api_endpoint" {
  description = "The API Gateway endpoint URL."
  value       = module.api_gateway.api_endpoint
}

output "api_id" {
  description = "The API Gateway ID."
  value       = module.api_gateway.api_id
}

output "authorizer_ids" {
  description = "Map of authorizer IDs."
  value       = module.api_gateway.authorizer_ids
}

output "vpc_link_ids" {
  description = "Map of VPC Link IDs."
  value       = module.api_gateway.vpc_link_ids
}
