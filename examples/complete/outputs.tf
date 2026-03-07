output "http_api_endpoint" {
  description = "The HTTP API Gateway endpoint URL."
  value       = module.http_api.api_endpoint
}

output "http_api_id" {
  description = "The HTTP API Gateway ID."
  value       = module.http_api.api_id
}

output "http_api_domain_name" {
  description = "The custom domain name for the HTTP API."
  value       = module.http_api.domain_name
}

output "http_api_domain_target" {
  description = "The target domain name for DNS configuration."
  value       = module.http_api.domain_name_target
}

output "http_api_stage_invoke_urls" {
  description = "Map of stage invoke URLs for the HTTP API."
  value       = module.http_api.stage_invoke_urls
}

output "websocket_api_endpoint" {
  description = "The WebSocket API Gateway endpoint URL."
  value       = module.websocket_api.api_endpoint
}

output "websocket_api_id" {
  description = "The WebSocket API Gateway ID."
  value       = module.websocket_api.api_id
}
