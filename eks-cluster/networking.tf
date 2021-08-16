data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.4.0"

  name = "${var.PREFIX}_${var.EKS_CLUSTER_NAME}_vpc"
  cidr = local.subnet_gateway_cidr_block
  azs = data.aws_availability_zones.available.names
  private_subnets = [ local.subnets.01.private_cidr_block, local.subnets.02.private_cidr_block ]
  public_subnets = [ local.subnets.01.public_cidr_block, local.subnets.02.public_cidr_block ]
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true

  map_public_ip_on_launch = false

  tags = {
    "kubernetes.io/cluster/${var.EKS_CLUSTER_NAME}" = "shared"
  }

  public_subnet_tags = {
    Application = "kubernetes",
    "kubernetes.io/cluster/${var.EKS_CLUSTER_NAME}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    Application = "kubernetes",
    "kubernetes.io/cluster/${var.EKS_CLUSTER_NAME}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
