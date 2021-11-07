#we need to create a Vpc resource.

resource "aws_vpc" "ntiervpc" {

    cidr_block = var.vpccidr
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
      "Name" = "Terraform VPC"
    }

}

#creating all subnets

resource "aws_subnet" "subnets_tf" {
  count = 6
  cidr_block = var.cidrranges[count.index]
  vpc_id = aws_vpc.ntiervpc.id
  availability_zone = var.subnets-azs[count.index]

  tags = {
    "Name" = var.subnets[count.index]
  }
  
}