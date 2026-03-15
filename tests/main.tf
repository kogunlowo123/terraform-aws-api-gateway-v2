terraform {
  required_version = ">= 1.7.0"
}

module "test" {
  source = "../"

  name          = "test-api"
  description   = "Test API Gateway"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_credentials = false
    allow_headers     = ["Content-Type", "Authorization"]
    allow_methods     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allow_origins     = ["https://example.com"]
    expose_headers    = []
    max_age           = 3600
  }

  routes = {
    "get-items" = {
      method           = "GET"
      path             = "/items"
      integration_type = "AWS_PROXY"
      integration_uri  = "arn:aws:lambda:us-east-1:123456789012:function:get-items"
    }
    "post-items" = {
      method           = "POST"
      path             = "/items"
      integration_type = "AWS_PROXY"
      integration_uri  = "arn:aws:lambda:us-east-1:123456789012:function:post-items"
    }
  }

  stages = {
    "prod" = {
      auto_deploy = true
      default_route_settings = {
        detailed_metrics_enabled = true
        throttling_burst_limit   = 100
        throttling_rate_limit    = 50
      }
    }
  }

  disable_execute_api_endpoint = false

  tags = {
    Test = "true"
  }
}
