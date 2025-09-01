variable "project" {
  description = "Project name prefix"
  type        = string
  default     = "farming-bv"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing AWS key pair to use for SSH"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH (e.g., your.ip.addr.0/32)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {
    "Environment" = "demo"
    "Owner"       = "security-eng"
  }
}
