# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-07

### Added

- Initial release of the terraform-aws-api-gateway-v2 module.
- Support for HTTP and WebSocket API Gateway protocols.
- JWT authorizer configuration with customizable identity sources, issuers, and audiences.
- VPC Link support for private integrations with configurable subnets and security groups.
- Custom domain name support with ACM certificate integration.
- Stage management with auto-deploy, access logging, and throttling settings.
- CORS configuration for HTTP APIs.
- CloudWatch Log Group creation for access logging.
- API mapping for custom domain names across stages.
- Option to disable the default execute-api endpoint.
- Basic, advanced, and complete usage examples.
