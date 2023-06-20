# Declare variables here, then use them in terraform.tfvars.
variable "service_name" {
	type = string
}

variable "vm_count" {
	type = number
}

variable "vm_pool" {
	type = string
}
