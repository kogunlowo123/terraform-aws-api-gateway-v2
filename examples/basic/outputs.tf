output "api_endpoint" {
  description = "The API Gateway endpoint URL."
  value       = module.api_gateway.api_endpoint
}

output "api_id" {
  description = "The API Gateway ID."
  value       = module.api_gateway.api_id
}
