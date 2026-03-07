provider "aws" {
  region = "us-east-1"
}

################################################################################
# HTTP API Gateway - Complete Example
################################################################################

module "http_api" {
  source = "../../"

  name          = "complete-http-api"
  description   = "Complete HTTP API Gateway with all features"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_credentials = true
    allow_headers     = ["Content-Type", "Authorization", "X-Api-Key"]
    allow_methods     = ["GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"]
    allow_origins     = ["https://app.example.com", "https://admin.example.com"]
    expose_headers    = ["X-Request-Id"]
    max_age           = 7200
  }

  routes = {
    "get-users" = {
      method          = "GET"
      path            = "/api/v1/users"
      integration_uri = "arn:aws:lambda:us-east-1:123456789012:function:get-users"
      authorizer_key  = "auth0"
    }
    "post-users" = {
      method          = "POST"
      path            = "/api/v1/users"
      integration_uri = "arn:aws:lambda:us-east-1:123456789012:function:create-user"
      authorizer_key  = "auth0"
    }
    "get-internal" = {
      method           = "GET"
      path             = "/api/v1/internal/data"
      integration_type = "HTTP_PROXY"
      integration_uri  = "http://internal-alb-123456.us-east-1.elb.amazonaws.com"
      authorizer_key   = "auth0"
    }
    "get-health" = {
      method          = "GET"
      path            = "/health"
      integration_uri = "arn:aws:lambda:us-east-1:123456789012:function:health"
    }
  }

  integrations = {
    "get-internal" = {
      connection_type = "VPC_LINK"
      vpc_link_key    = "internal"
    }
  }

  authorizers = {
    "auth0" = {
      type             = "JWT"
      identity_sources = ["$request.header.Authorization"]
      issuer           = "https://example.auth0.com/"
      audience         = ["https://api.example.com"]
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
      access_log_settings = {
        destination_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/apigateway/complete-http-api/default"
      }
      default_route_settings = {
        detailed_metrics_enabled = true
        throttling_burst_limit   = 500
        throttling_rate_limit    = 1000
      }
    }
    "staging" = {
      auto_deploy = false
      access_log_settings = {
        destination_arn = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/apigateway/complete-http-api/staging"
      }
      default_route_settings = {
        detailed_metrics_enabled = true
        throttling_burst_limit   = 100
        throttling_rate_limit    = 200
      }
      stage_variables = {
        environment = "staging"
      }
    }
  }

  domain_name            = "api.example.com"
  domain_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abc123-def456"

  disable_execute_api_endpoint = true

  tags = {
    Environment = "production"
    Project     = "complete-example"
    ManagedBy   = "terraform"
  }
}

################################################################################
# WebSocket API Gateway
################################################################################

module "websocket_api" {
  source = "../../"

  name          = "complete-websocket-api"
  description   = "Complete WebSocket API Gateway"
  protocol_type = "WEBSOCKET"

  routes = {
    "connect" = {
      path            = "$connect"
      integration_uri = "arn:aws:lambda:us-east-1:123456789012:function:ws-connect"
      authorizer_key  = "ws-auth"
    }
    "disconnect" = {
      path            = "$disconnect"
      integration_uri = "arn:aws:lambda:us-east-1:123456789012:function:ws-disconnect"
    }
    "default" = {
      path            = "$default"
      integration_uri = "arn:aws:lambda:us-east-1:123456789012:function:ws-default"
    }
    "send-message" = {
      path            = "sendMessage"
      integration_uri = "arn:aws:lambda:us-east-1:123456789012:function:ws-send-message"
    }
  }

  authorizers = {
    "ws-auth" = {
      type             = "JWT"
      identity_sources = ["route.request.querystring.token"]
      issuer           = "https://cognito-idp.us-east-1.amazonaws.com/us-east-1_EXAMPLE"
      audience         = ["ws-client-id"]
    }
  }

  stages = {
    "production" = {
      auto_deploy = true
      default_route_settings = {
        detailed_metrics_enabled = true
        logging_level            = "INFO"
        throttling_burst_limit   = 500
        throttling_rate_limit    = 1000
      }
    }
  }

  tags = {
    Environment = "production"
    Project     = "complete-example"
    ManagedBy   = "terraform"
  }
}
