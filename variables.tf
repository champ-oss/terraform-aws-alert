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

variable "ecr_account" {
  description = "AWS account of ECR repository"
  type        = string
  default     = ""
}

variable "ecr_name" {
  description = "Name of ECR repository"
  type        = string
  default     = ""
}

variable "ecr_tag" {
  description = "Tag of ECR image"
  type        = string
  default     = ""
}

variable "sync_image" {
  description = "Sync a specific docker image tag from another location (ex: Docker Hub) to ECR"
  type        = bool
  default     = false
}

variable "sync_source_repo" {
  description = "Name of the source docker repo to sync (ex: myaccount/myrepo)"
  type        = string
  default     = ""
}

variable "image_uri" {
  description = "default image uri"
  type        = string
  default     = ""
}
