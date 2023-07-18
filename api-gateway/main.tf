terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  shared_config_files      = ["/home/shreshth/.aws/config"]
  shared_credentials_files = ["/home/shreshth/.aws/credentials"]
  profile                  = "default"
}

resource "aws_api_gateway_rest_api" "test" {
  name = "api-gateway"
}
resource "aws_api_gateway_resource" "um" {
  rest_api_id = "${aws_api_gateway_rest_api.test.id}"
  parent_id   = "${aws_api_gateway_rest_api.test.root_resource_id}"
  path_part   = "um"
}
resource "aws_api_gateway_method" "um_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.test.id}"
  resource_id   = "${aws_api_gateway_resource.um.id}"
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}
resource "aws_api_gateway_resource" "company" {
  rest_api_id = "${aws_api_gateway_rest_api.test.id}"
  parent_id   = "${aws_api_gateway_rest_api.test.root_resource_id}"
  path_part   = "company"
}
resource "aws_api_gateway_method" "company_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.test.id}"
  resource_id   = "${aws_api_gateway_resource.company.id}"
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_resource" "executive" {
  rest_api_id = "${aws_api_gateway_rest_api.test.id}"
  parent_id   = "${aws_api_gateway_rest_api.test.root_resource_id}"
  path_part   = "executive"
}
resource "aws_api_gateway_method" "executive_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.test.id}"
  resource_id   = "${aws_api_gateway_resource.executive.id}"
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}
resource "aws_api_gateway_resource" "admin" {
  rest_api_id = "${aws_api_gateway_rest_api.test.id}"
  parent_id   = "${aws_api_gateway_rest_api.test.root_resource_id}"
  path_part   = "admin"
}
resource "aws_api_gateway_method" "admin_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.test.id}"
  resource_id   = "${aws_api_gateway_resource.admin.id}"
  http_method   = "ANY"
  authorization = "NONE"
  request_parameters = {
    "method.request.path.proxy" = true
  }
}

