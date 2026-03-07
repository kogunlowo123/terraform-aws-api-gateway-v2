locals {
  create_domain    = var.domain_name != null && var.domain_certificate_arn != null
  create_log_group = { for k, v in var.stages : k => v if v.access_log_settings != null }

  default_log_format = jsonencode({
    requestId         = "$context.requestId"
    ip                = "$context.identity.sourceIp"
    requestTime       = "$context.requestTime"
    httpMethod        = "$context.httpMethod"
    routeKey          = "$context.routeKey"
    status            = "$context.status"
    protocol          = "$context.protocol"
    responseLength    = "$context.responseLength"
    integrationError  = "$context.integrationErrorMessage"
  })

  routes_with_authorizers = {
    for k, v in var.routes : k => v if v.authorizer_key != null
  }
}
