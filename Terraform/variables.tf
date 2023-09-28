
variable "ARM_CLIENT_ID" {
	description = "Service principal client ID"
	type = string
	sensitive = true
}

variable "ARM_CLIENT_SECRET" {
	description = "Service principal client password"
	type = string
	sensitive = true
}

variable "ARM_SUBSCRIPTION_ID" {
	description = "Azure subscription ID"
	type = string
	sensitive = true
}

variable "ARM_TENANT_ID" {
	description = "Tenant ID"
	type = string
	sensitive = true
}
