output "api_id" {
  description = "The ID of the API Gateway"
  value       = aws_apigatewayv2_api.this.id
}

output "api_arn" {
  description = "The ARN of the API Gateway"
  value       = aws_apigatewayv2_api.this.arn
}

output "api_endpoint" {
  description = "The URI of the API Gateway"
  value       = aws_apigatewayv2_api.this.api_endpoint
}

output "api_execution_arn" {
  description = "The execution ARN of the API Gateway"
  value       = aws_apigatewayv2_api.this.execution_arn
}

output "stage_ids" {
  description = "Map of stage names to their IDs"
  value       = { for k, v in aws_apigatewayv2_stage.this : k => v.id }
}

output "stage_arns" {
  description = "Map of stage names to their ARNs"
  value       = { for k, v in aws_apigatewayv2_stage.this : k => v.arn }
}

output "stage_invoke_urls" {
  description = "Map of stage names to their invoke URLs"
  value       = { for k, v in aws_apigatewayv2_stage.this : k => v.invoke_url }
}

output "route_ids" {
  description = "Map of route keys to their IDs"
  value       = { for k, v in aws_apigatewayv2_route.this : k => v.id }
}

output "integration_ids" {
  description = "Map of integration keys to their IDs"
  value       = { for k, v in aws_apigatewayv2_integration.this : k => v.id }
}

output "authorizer_ids" {
  description = "Map of authorizer names to their IDs"
  value       = { for k, v in aws_apigatewayv2_authorizer.this : k => v.id }
}

output "vpc_link_ids" {
  description = "Map of VPC link names to their IDs"
  value       = { for k, v in aws_apigatewayv2_vpc_link.this : k => v.id }
}

output "vpc_link_arns" {
  description = "Map of VPC link names to their ARNs"
  value       = { for k, v in aws_apigatewayv2_vpc_link.this : k => v.arn }
}

output "domain_name" {
  description = "The custom domain name"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name, null)
}

output "domain_name_target" {
  description = "The target domain name for DNS CNAME or alias"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].target_domain_name, null)
}

output "domain_name_hosted_zone_id" {
  description = "The Route 53 hosted zone ID for the custom domain"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].hosted_zone_id, null)
}

output "log_group_arns" {
  description = "Map of stage names to their CloudWatch Log Group ARNs"
  value       = { for k, v in aws_cloudwatch_log_group.this : k => v.arn }
}
