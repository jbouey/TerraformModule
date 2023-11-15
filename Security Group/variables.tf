variable "security_group_name" {
  type        = string
  description = "Name for the security group"
}

variable "security_group_description" {
  type        = string
  description = "Description for the security group"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC where the security group will be created"
}

variable "ingress_rules" {
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "List of ingress (inbound) rules"
}

variable "egress_rules" {
  type        = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "List of egress (outbound) rules"
}

# environment variable
variable "project_name" {}
variable "environment" {}
variable "ssh_ip" {}

