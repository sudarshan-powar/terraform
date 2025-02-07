#######################################
# Route 53 Variables
# This file defines the input variables for the Route 53 module.
#######################################

variable "DOMAIN_NAME" {
  description = "Domain name of the project"  # Specifies the domain for the hosted zone
  type        = string
}

variable "FORCE_DESTROY" {
  description = "This will destroy all the records if enabled"  # If true, allows deletion of all records upon destruction
  type        = bool
  default     = false
}