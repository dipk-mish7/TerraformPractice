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
  cidr_block = cidrsubnet(var.vpccidr,8,count.index)
  vpc_id = aws_vpc.ntiervpc.id
  availability_zone = "${var.region}${count.index%2 == 0 ? "a":"b"}"
  tags = {
    "Name" = local.subnets[count.index]
  }

  depends_on = [
    aws_vpc.ntiervpc
  ]
  
}

#creating igw

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ntiervpc.id

  tags = {
    "Name" = local.igw_ntier
  }

  depends_on = [
    aws_vpc.ntiervpc
  ]

  
}