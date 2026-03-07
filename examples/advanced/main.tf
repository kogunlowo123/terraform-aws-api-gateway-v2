provider "aws" {
  region = "us-east-1"
}

module "api_gateway" {
  source = "../../"

  name          = "advanced-http-api"
  description   = "Advanced HTTP API Gateway with JWT authorizer and VPC Link"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["Content-Type", "Authorization"]
    allow_methods = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_origins = ["https://example.com"]
    max_age       = 3600
  }

  routes = {
    "get-users" = {
      method          = "GET"
      path            = "/users"
      integration_uri = "arn:aws:lambda:us-east-1:123456789012:function:get-users"
      authorizer_key  = "cognito"
    }
    "post-users" = {
      method          = "POST"
      path            = "/users"
      integration_uri = "arn:aws:lambda:us-east-1:123456789012:function:create-user"
      authorizer_key  = "cognito"
    }
    "get-health" = {
      method          = "GET"
      path            = "/health"
      integration_uri = "arn:aws:lambda:us-east-1:123456789012:function:health-check"
    }
  }

  authorizers = {
    "cognito" = {
      type             = "JWT"
      identity_sources = ["$request.header.Authorization"]
      issuer           = "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_EXAMPLE"
      audience         = ["my-api-client-id"]
    }
  }

  vpc_links = {
    "internal" = {
      subnet_ids         = ["subnet-abc123", "subnet-def456"]
      security_group_ids = ["sg-abc123"]
    }
  }

  stages = {
    "$default" = {
      auto_deploy = true
      default_route_settings = {
        detailed_metrics_enabled = true
        throttling_burst_limit   = 100
        throttling_rate_limit    = 50
      }
    }
  }

  disable_execute_api_endpoint = true

  tags = {
    Environment = "staging"
    Project     = "advanced-example"
  }
}
