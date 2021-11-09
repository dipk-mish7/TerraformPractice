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

#creating route public table

resource "aws_route_table" "publicroutetable" {

  vpc_id = aws_vpc.ntiervpc.id
  route {
    cidr_block = local.anywhere
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name" = "PublicRT"
  }

  depends_on = [
    aws_vpc.ntiervpc,
    aws_subnet.subnets_tf[0],
    aws_subnet.subnets_tf[1]
  ]
}

#creating routetable association.

resource "aws_route_table_association" "websubnets" {

  count = 2

  subnet_id = aws_subnet.subnets_tf[count.index].id
  route_table_id = aws_route_table.publicroutetable.id

  depends_on = [
    aws_route_table.publicroutetable
  ]

}

#creating private route table
  
resource "aws_route_table" "private_routetable" {

  vpc_id = aws_vpc.ntiervpc.id
  tags = {
    "Name" = "PrivateRouteTable"
  }

  depends_on = [
    aws_vpc.ntiervpc,
    aws_subnet.subnets_tf[2],
    aws_subnet.subnets_tf[3],
    aws_subnet.subnets_tf[4],
    aws_subnet.subnets_tf[5]
  ]

}

#creating private route table association 
resource "aws_route_table_association" "appdbsubnets" {
  count = 4
  subnet_id = aws_subnet.subnets_tf[count.index+2].id
  route_table_id = aws_route_table.private_routetable.id

  depends_on = [
    aws_route_table.private_routetable
  ]
}