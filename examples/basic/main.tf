provider "aws" {
  region = "us-east-1"
}

module "api_gateway" {
  source = "../../"

  name          = "basic-http-api"
  description   = "Basic HTTP API Gateway example"
  protocol_type = "HTTP"

  routes = {
    "get-hello" = {
      method          = "GET"
      path            = "/hello"
      integration_uri = "arn:aws:lambda:us-east-1:123456789012:function:hello"
    }
  }

  stages = {
    "$default" = {
      auto_deploy = true
    }
  }

  tags = {
    Environment = "dev"
    Project     = "basic-example"
  }
}
