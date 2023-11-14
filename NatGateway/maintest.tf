# Objective: Allocate Elastic IPs for NAT gateways in two public subnets (az1 and az2).

# Allocate Elastic IP for NAT gateway in public subnet az1
resource "aws_eip" "eip_for_nat_gateway_az1" {
  vpc = true # Specify the VPC ID

  tags = {
    Name = "natgateway_az1_eip"
  }
}

# Allocate Elastic IP for NAT gateway in public subnet az2
resource "aws_eip" "eip_for_nat_gateway_az2" {
  vpc = true # Specify the VPC ID

  tags = {
    Name = "natgateway_az2_eip"
  }
}

# Objective: Create NAT gateways in two public subnets (az1 and az2).

# Create NAT gateway in public subnet az1
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway_az1.id # Reference the Elastic IP resource above
  subnet_id     = "subnet-az1" # Specify the subnet ID for az1

  tags = {
    Name = "nat_gateway_az1"
  }

  # To ensure proper ordering, add explicit dependencies as needed
  depends_on = []
}

# Create NAT gateway in public subnet az2
resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip_for_nat_gateway_az2.id # Reference the Elastic IP resource above
  subnet_id     = "subnet-az2" # Specify the subnet ID for az2

  tags = {
    Name = "nat_gateway_az2"
  }

  # To ensure proper ordering, add explicit dependencies as needed
  depends_on = [aws_internet_gateway.example] # Example: Add dependency on an Internet Gateway
}

# Objective: Create private route tables and associate them with subnets.

# Create private route table for az1 and add a route through NAT gateway az1
resource "aws_route_table" "private_route_table_az1" {
  vpc_id = "your_vpc_id" # Specify the VPC ID

  route {
    cidr_block     = "0.0.0.0/0" # Specify the destination CIDR block
    nat_gateway_id = aws_nat_gateway.nat_gateway_az1.id # Reference the NAT Gateway above
  }

  tags = {
    Name = "private_route_table_az1"
  }
}

# Associate private app subnet az1 with private route table az1
resource "aws_route_table_association" "private_app_subnet_az1" {
  subnet_id      = "subnet-app-az1" # Specify the app subnet ID
  route_table_id = aws_route_table.private_route_table_az1.id # Reference the route table above
}

# Associate private data subnet az1 with private route table az1
resource "aws_route_table_association" "private_data_subnet_az1" {
  subnet_id      = "subnet-data-az1" # Specify the data subnet ID
  route_table_id = aws_route_table.private_route_table_az1.id # Reference the route table above
}

# Similar blocks for az2 can be created with appropriate IDs and references.
