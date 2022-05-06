variable "git" {
  description = "Name of the Git repo"
  type        = string
  default     = "terraform-aws-alert"
}

variable "slack_url" {
  description = "slack url"
  type        = string
}

variable "region" {
  description = "region of cloudwatch alarm. only used for console url"
  type        = string
}

