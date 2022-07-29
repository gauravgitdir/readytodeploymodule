
variable "db_engine" {
type = string
}

variable "account_id" {
type = number
}

variable "db_cluster_instance_name" {
type = string
}

variable "db_admin_username" {
type = string
}

variable "db_name" {
type = string
}


variable "db_admin_password" {
type = string
}

variable "instance_count" {
type = string
}

variable "environment" {
type = string
}

variable "vpc_name" {
type = string
}


variable "db_security_group_name" {
type = string
}


variable "component" {
type = string
}


variable "freeable_threshold" {
type = number
}

variable "trans_wrap_threshold" {
type = number
}

variable "audit_auth_namespace" {
type = string
}

variable "cidr_block" {
type = string
}


variable "instance_tenancy" {
type = string
}

variable "cidr_block_vpc" {
type = string
}

variable "dns_name" {
type = string
}

variable "type" {
type = string
}

variable "secret_key" {
type = string
}

