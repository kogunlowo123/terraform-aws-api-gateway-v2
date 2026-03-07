variable "name" {
  description = "The name of the API Gateway."
  type        = string
}

variable "description" {
  description = "The description of the API Gateway."
  type        = string
  default     = ""
}

variable "protocol_type" {
  description = "The API protocol type. Valid values: HTTP, WEBSOCKET."
  type        = string
  default     = "HTTP"

  validation {
    condition     = contains(["HTTP", "WEBSOCKET"], var.protocol_type)
    error_message = "Protocol type must be either HTTP or WEBSOCKET."
  }
}

variable "cors_configuration" {
  description = "CORS configuration for the API Gateway (HTTP APIs only)."
  type = object({
    allow_credentials = optional(bool, false)
    allow_headers     = optional(list(string), [])
    allow_methods     = optional(list(string), [])
    allow_origins     = optional(list(string), [])
    expose_headers    = optional(list(string), [])
    max_age           = optional(number, 0)
  })
  default = null
}

variable "routes" {
  description = "Map of route configurations for the API Gateway."
  type = map(object({
    method           = optional(string, "ANY")
    path             = string
    integration_type = optional(string, "AWS_PROXY")
    integration_uri  = string
    authorizer_key   = optional(string, null)
  }))
  default = {}
}

variable "integrations" {
  description = "Map of integration configurations for the API Gateway."
  type        = map(any)
  default     = {}
}

variable "authorizers" {
  description = "Map of authorizer configurations for the API Gateway."
  type = map(object({
    type             = optional(string, "JWT")
    identity_sources = optional(list(string), ["$request.header.Authorization"])
    issuer           = optional(string, null)
    audience         = optional(list(string), [])
  }))
  default = {}
}

variable "stages" {
  description = "Map of stage configurations for the API Gateway."
  type = map(object({
    auto_deploy = optional(bool, true)
    access_log_settings = optional(object({
      destination_arn = string
      format          = optional(string, null)
    }), null)
    default_route_settings = optional(object({
      detailed_metrics_enabled = optional(bool, false)
      logging_level            = optional(string, null)
      throttling_burst_limit   = optional(number, null)
      throttling_rate_limit    = optional(number, null)
    }), null)
    throttling = optional(object({
      burst_limit = optional(number, null)
      rate_limit  = optional(number, null)
    }), null)
    stage_variables = optional(map(string), {})
  }))
  default = {}
}

variable "vpc_links" {
  description = "Map of VPC Link configurations for the API Gateway."
  type = map(object({
    subnet_ids         = list(string)
    security_group_ids = list(string)
  }))
  default = {}
}

variable "domain_name" {
  description = "Custom domain name for the API Gateway."
  type        = string
  default     = null
}

variable "domain_certificate_arn" {
  description = "ARN of the ACM certificate for the custom domain."
  type        = string
  default     = null
}

variable "disable_execute_api_endpoint" {
  description = "Whether to disable the default execute-api endpoint."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}
