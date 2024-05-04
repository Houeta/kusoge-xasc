locals {
  global_prefix = "${var.project}-${var.env}"

  aws_tags = merge(var.tags, {
    "Created by" = "Terraform"
    "Project" = var.project
    "Environment" = var.env
  })
}

# General
variable "env" {
  description = "Environment name"
  type = string
}

variable "project" {
  description = "Project name"
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnets_ids" {
  type = list(string)
}

variable "zone_name" {
  type = string
}

variable "tags" {
  type = map(any)
  default = {}
}

variable "argocd_github_client_id" {
  description = "GitHub OAuth application client id"
  type = string
  sensitive = true
}

variable "argocd_github_client_secret" {
  description = "GitHub OAuth application client secret"
  type = string
  sensitive = true
}

variable "argocd_github_org_name" {
  description = "Github organisation name"
  type = string
  sensitive = true
}

#Optional
variable "region" {
  description = "Active AWS region for infrastructure"
  type = string
  default = "eu-central-1"

  validation {
    condition = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Must be valid AWS region names."
  }
}

variable "iam_profile" {
  description = "What profile is used to execute Terraform"
  type = string
  default = "default"
}

variable "node_ami_type" {
  description = "Select an AMI to use. More details: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ComponentsAMIs.html"
  type = string
  default = "AL2_x86_64"
}

variable "node_instances_type" {
  description = "The type of instances to start"
  type = list(string)
  default = ["t3.medium"]
}

variable "node_additional_tags" {
  description = "Additional tags for the instance"
  type        = map(string)
  default     = {}
}

variable "argocd_namespace" {
  type = string
  default = ""
}

variable "argocd_helmchart_version" {
  type = string
  default = ""
}