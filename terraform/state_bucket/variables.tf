variable "project" {
  description = "Project name"
  type        = string
}

variable "profile" {
  type    = string
  default = ""
}

variable "region" {
  type = string
}

variable "username" {
  description = "Owner's username"
  type        = string
}

variable "tags" {
  type    = map(any)
  default = {}
}
