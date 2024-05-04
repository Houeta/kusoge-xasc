# General

variable "env" {
  description = "Environment name"
  type = string
}

variable "project" {
  description = "Project name"
  type = string
}

variable "profile" {
  description = "What profile is used to execute Terraform"
  type = string
  default = "default"
}

variable "region" {
  description = "Active AWS region for infrastructure"
  type = string
  default = "eu-central-1"

  validation {
    condition = can(regex("[a-z][a-z]-[a-z]+-[1-9]", var.region))
    error_message = "Must be valid AWS region names."
  }
}

variable "tags" {
  type = map(any)
  default = {}
}

locals {
  global_prefix = "${var.project}-${var.env}"

  aws_tags = merge(var.tags, {
    "Created by" = "Terraform"
    "Project" = var.project
    "Environment" = var.env
  })
}

# VPC VARs

variable "vpc_cidr" {
  description = "CIDR block for VPC, by default: '10.0.0.0/16'"
  type = string
  default = "10.0.0.0/16"

  validation {
    condition = can(cidrhost(var.vpc_cidr, 0))
    error_message = "The VPC block must be valid IPv4 CIDR"
  }
}

variable "sg_add_ssh_port" {
  description = "Do you want to add ssh port on your IP?"
  default = false
}

# EKS VARs

variable "kubernetes_version" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3.medium"
}

variable "node_min_size" {
  type = number
  default = 1
}

variable "node_desired_size" {
  type = number
  default = 1
}

variable "node_max_size" {
  type = number
  default = 3
}

variable "addons" {
  description = "Kubernetes addons "
  type = any
  default = {
    enable_aws_ebs_csi_driver = true
    enable_aws_load_balancer_controller = true
    enable_aws_for_fluentbit = true
    enable_cluster_autoscaler = true
    enable_metrics_server = true
    enable_external_dns = true
    enable_argocd = true
    enable_argo_rollouts = true
    enable_argo_events = true
    enable_argo_workflows = true
    enable_ingress_nginx = true
  }
}

# Route53 VARs
variable "hosted_zone_name" {
  type = string
}

# GitOps
variable "gitops_addons_org" {
  description = "Git repository org/user contains for addons"
  type        = string
  default     = "https://github.com/gitops-bridge-dev"
}

variable "gitops_addons_repo" {
  description = "Git repository contains for addons"
  type        = string
  default     = "gitops-bridge-argocd-control-plane-template"
}

variable "gitops_addons_revision" {
  description = "Git repository revision/branch/ref for addons"
  type        = string
  default     = "main"
}

variable "gitops_addons_basepath" {
  description = "Git repository base path for addons"
  type        = string
  default     = ""
}

variable "gitops_addons_path" {
  description = "Git repository path for addons"
  type        = string
  default     = "bootstrap/control-plane/addons"
}