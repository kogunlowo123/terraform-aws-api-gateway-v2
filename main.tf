################################################################################
# API Gateway V2
################################################################################

resource "aws_apigatewayv2_api" "this" {
  name          = var.name
  description   = var.description
  protocol_type = var.protocol_type

  disable_execute_api_endpoint = var.disable_execute_api_endpoint

  dynamic "cors_configuration" {
    for_each = var.cors_configuration != null && var.protocol_type == "HTTP" ? [var.cors_configuration] : []

    content {
      allow_credentials = cors_configuration.value.allow_credentials
      allow_headers     = cors_configuration.value.allow_headers
      allow_methods     = cors_configuration.value.allow_methods
      allow_origins     = cors_configuration.value.allow_origins
      expose_headers    = cors_configuration.value.expose_headers
      max_age           = cors_configuration.value.max_age
    }
  }

  tags = var.tags
}

################################################################################
# Stages
################################################################################

resource "aws_apigatewayv2_stage" "this" {
  for_each = var.stages

  api_id      = aws_apigatewayv2_api.this.id
  name        = each.key
  auto_deploy = each.value.auto_deploy

  dynamic "access_log_settings" {
    for_each = each.value.access_log_settings != null ? [each.value.access_log_settings] : []

    content {
      destination_arn = access_log_settings.value.destination_arn
      format          = coalesce(access_log_settings.value.format, var.default_log_format)
    }
  }

  dynamic "default_route_settings" {
    for_each = each.value.default_route_settings != null ? [each.value.default_route_settings] : []

    content {
      detailed_metrics_enabled = default_route_settings.value.detailed_metrics_enabled
      logging_level            = var.protocol_type == "WEBSOCKET" ? default_route_settings.value.logging_level : null
      throttling_burst_limit   = default_route_settings.value.throttling_burst_limit
      throttling_rate_limit    = default_route_settings.value.throttling_rate_limit
    }
  }

  stage_variables = each.value.stage_variables

  tags = var.tags
}

################################################################################
# Routes
################################################################################

resource "aws_apigatewayv2_route" "this" {
  for_each = var.routes

  api_id    = aws_apigatewayv2_api.this.id
  route_key = var.protocol_type == "HTTP" ? "${each.value.method} ${each.value.path}" : each.value.path

  target             = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"
  authorization_type = each.value.authorizer_key != null ? "JWT" : "NONE"
  authorizer_id      = each.value.authorizer_key != null ? aws_apigatewayv2_authorizer.this[each.value.authorizer_key].id : null
}

################################################################################
# Integrations
################################################################################

resource "aws_apigatewayv2_integration" "this" {
  for_each = var.routes

  api_id             = aws_apigatewayv2_api.this.id
  integration_type   = each.value.integration_type
  integration_uri    = each.value.integration_uri
  integration_method = var.protocol_type == "HTTP" ? each.value.method : null

  connection_type = lookup(var.integrations, each.key, null) != null ? lookup(var.integrations[each.key], "connection_type", "INTERNET") : "INTERNET"
  connection_id   = lookup(var.integrations, each.key, null) != null ? (
    lookup(var.integrations[each.key], "vpc_link_key", null) != null ? aws_apigatewayv2_vpc_link.this[var.integrations[each.key].vpc_link_key].id : null
  ) : null

  payload_format_version = var.protocol_type == "HTTP" ? "2.0" : null
}

################################################################################
# Authorizers
################################################################################

resource "aws_apigatewayv2_authorizer" "this" {
  for_each = var.authorizers

  api_id           = aws_apigatewayv2_api.this.id
  authorizer_type  = each.value.type
  name             = each.key
  identity_sources = each.value.identity_sources

  dynamic "jwt_configuration" {
    for_each = each.value.type == "JWT" ? [1] : []

    content {
      issuer   = each.value.issuer
      audience = each.value.audience
    }
  }
}

################################################################################
# VPC Links
################################################################################

resource "aws_apigatewayv2_vpc_link" "this" {
  for_each = var.vpc_links

  name               = "${var.name}-${each.key}"
  subnet_ids         = each.value.subnet_ids
  security_group_ids = each.value.security_group_ids

  tags = var.tags
}

################################################################################
# Custom Domain
################################################################################

resource "aws_apigatewayv2_domain_name" "this" {
  count = var.domain_name != null && var.domain_certificate_arn != null ? 1 : 0

  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.domain_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  tags = var.tags
}

resource "aws_apigatewayv2_api_mapping" "this" {
  for_each = var.domain_name != null && var.domain_certificate_arn != null ? var.stages : {}

  api_id      = aws_apigatewayv2_api.this.id
  domain_name = aws_apigatewayv2_domain_name.this[0].id
  stage       = aws_apigatewayv2_stage.this[each.key].id
}

################################################################################
# CloudWatch Log Group
################################################################################

resource "aws_cloudwatch_log_group" "this" {
  for_each = { for k, v in var.stages : k => v if v.access_log_settings != null }

  name              = "/aws/apigateway/${var.name}/${each.key}"
  retention_in_days = 30

  tags = var.tags
}
