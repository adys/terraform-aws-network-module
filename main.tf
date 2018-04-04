module "network" {
  source             = "modules/network"
  environment_name   = "${var.environment_name}"
  vpc_subnet         = "${var.vpc_subnet}"
  public_subnets     = "${var.public_subnets}"
  private_subnets    = "${var.private_subnets}"
  availability_zones = "${var.availability_zones}"
}

provider "aws" {
  region = "${var.aws_region}"
}