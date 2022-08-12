# terraform-aws-alert #

Summary: AWS Lambda function written in python post slack message when there is an ERROR in cloudwatch logs.  This uses log subscription filter and lambda resources automated with Terraform.

![ci](https://github.com/conventional-changelog/standard-version/workflows/ci/badge.svg)
[![version](https://img.shields.io/badge/version-1.x-yellow.svg)](https://semver.org)

## Table of Contents
* [General Info](#general-information)
* [Technologies Used](#technologies-used)
* [Features](#Features)
* [Usage](#usage)
* [Project Status](#project-status)

## General Information
- automate setup of terraform-aws-alert

## Technologies Used
- terraform
- github actions
- python script using slack api
- lambda
- AWS Cloudwatch log subscription filter

## Features

* create log subscription filter
* lambda function that parses cloudwatch logEvents
* POST slack message
    * message includes console link to log stream error
    * link filter using timestamp
    * account
    * log group
    * log stream 
    * error 

## Usage

* look at examples/basic/main.tf for example

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | github.com/champ-oss/terraform-aws-lambda.git | v1.0.78-e44be7d |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_subscription_filter.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_lambda_permission.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [random_string.identifier](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [archive_file.lambda_zip](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_filter_pattern"></a> [filter\_pattern](#input\_filter\_pattern) | https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html#extract-log-event-values | `string` | `"ERROR"` | no |
| <a name="input_git"></a> [git](#input\_git) | Name of the Git repo | `string` | n/a | yes |
| <a name="input_log_group_name"></a> [log\_group\_name](#input\_log\_group\_name) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter#log_group_name | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Unique identifier for naming resources | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | region of cloudwatch alarm. only used for console url | `string` | `"us-east-2"` | no |
| <a name="input_slack_url"></a> [slack\_url](#input\_slack\_url) | slack url | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to assign to resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group"></a> [cloudwatch\_log\_group](#output\_cloudwatch\_log\_group) | alarm name output |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | function arn |
<!-- END_TF_DOCS -->

## Project Status
Project is: _in_progress_ 
