variable "nat_subnet_cidr" {
  default = "10.0.4.0/24"
}

variable "webserver_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "lambda_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "availability_zone" {
  default = "us-west-2a"
}

variable "region" {
  default = "us-west-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "zero_address_default_route_cidr" {
  default = "0.0.0.0/0"
}

variable "enable_authorizer" {
  default = false
}

