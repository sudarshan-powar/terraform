#######################################
# VPC Configuration
# This file defines the VPC setup for the project.
#######################################

variable "PROJECT_VPC_NAME" {
  description = "Name for VPC"
  type        = string
}

variable "VPC_CIDR_BLOCK" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "PUBLIC_SUBNET_CIDR_1" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.0.0/20"
}

variable "PUBLIC_SUBNET_CIDR_2" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.0.32.0/20"
}

variable "PRIVATE_SUBNET_CIDR_1" {
  description = "CIDR block for public subnet 1"
  type        = string
  default     = "10.0.16.0/20"
}

variable "PRIVATE_SUBNET_CIDR_2" {
  description = "CIDR block for public subnet 2"
  type        = string
  default     = "10.0.48.0/20"
}

variable "IPV6_ON_CREATION" {
  description = "Specify true to indicate that subnet should be assigned with an IPv6 address"
  type        = bool
  default     = false
}

variable "AZ_PUBLIC_1" {
  description = "Specify Availability Zone for subnets"
  type        = string
}

variable "AZ_PUBLIC_2" {
  description = "Specify Availability Zone for subnets"
  type        = string
}

variable "AZ_PRIVATE_1" {
  description = "Specify Availability Zone for subnets"
  type        = string
}

variable "AZ_PRIVATE_2" {
  description = "Specify Availability Zone for subnets"
  type        = string
}