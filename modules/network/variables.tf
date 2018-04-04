variable "environment_name" {
  description = "environment name"
}

variable "vpc_subnet" {
  description = "vpc subnet"
}

variable "public_subnets" {
  type        = "list"
  description = "public subnets"
}

variable "private_subnets" {
  type        = "list"
  description = "private subnets"
}

variable "availability_zones" {
  type        = "list"
  description = "availability zones"
}