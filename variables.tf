variable "tags" {
  description = "Map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "git" {
  description = "Name of the Git repo"
  type        = string
}

variable "name" {
  description = "Unique identifier for naming resources"
  type        = string
}

variable "log_group_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_metric_filter#log_group_name"
  type        = string
}

variable "filter_pattern" {
  description = "https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/FilterAndPatternSyntax.html#extract-log-event-values"
  type        = string
  default     = "ERROR"
}

variable "slack_url" {
  description = "slack url"
  type        = string
}

variable "region" {
  description = "region of cloudwatch alarm. only used for console url"
  type        = string
  default     = "us-east-2"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  type        = bool
  default     = true
}

variable "package_type" {
  description = "The Lambda deployment package type. Valid values: Zip, Image"
  type        = string
  default     = "Zip"
}

variable "image_uri" {
  description = "The URI of the container image that contains your function code"
  type        = string
  default     = ""
}
