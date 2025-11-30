# Network module: VPC, public subnets, private subnets, and basic routing.

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Project"] != "" ? var.tags["Project"] : "eks"}-vpc"
    }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Project"] != "" ? var.tags["Project"] : "eks"}-igw"
    }
  )
}

# Public subnets and route table

resource "aws_subnet" "public" {
  for_each = {
    for idx, cidr in var.public_subnet_cidrs :
    idx => cidr
  }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  availability_zone       = var.azs[tonumber(each.key)]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Project"] != "" ? var.tags["Project"] : "eks"}-public-${each.key}"
      Tier = "public"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Project"] != "" ? var.tags["Project"] : "eks"}-public-rt"
    }
  )
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private subnets (optional NAT gateway or direct routing could be extended here)

resource "aws_subnet" "private" {
  for_each = {
    for idx, cidr in var.private_subnet_cidrs :
    idx => cidr
  }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = var.azs[tonumber(each.key)]

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Project"] != "" ? var.tags["Project"] : "eks"}-private-${each.key}"
      Tier = "private"
    }
  )
}

# For simplicity, private subnets are associated with the main route table.
# In a real production setup, this could be extended with NAT gateways
# and dedicated private route tables.

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = merge(
    var.tags,
    {
      Name = "${var.tags["Project"] != "" ? var.tags["Project"] : "eks"}-default-rt"
    }
  )
}
