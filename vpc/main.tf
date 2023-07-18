resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  
  tags = {
    Name = var.environment_name
  }
}



resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidr)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.public_subnet_cidr, count.index)
 availability_zone = element(var.availability_zone,count.index)
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}

resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnet_cidr)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.private_subnet_cidr, count.index)
 availability_zone = element(var.availability_zone,count.index)
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}

resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = "SL VPC IG"
 }
}

/*
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gw.id

  tags = {
    Name = "SL NAT GW"
  }
}
*/

resource "aws_route_table" "public_route" {
  vpc_id =    aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
      
}


resource "aws_default_route_table" "private_route" {
//  vpc_id = aws_vpc.main.id
  default_route_table_id = aws_vpc.main.main_route_table_id
}


//resource "aws_route_table" "private_route" {
//  vpc_id = aws_vpc.main.id
  
/*    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id  =   aws_nat_gateway.nat_gw.id
    }
    route { 
        cidr_block = var.vpc_cidr
        
    }
*/
//}



resource "aws_route_table_association" "private_route" {
    count = length(aws_subnet.private_subnets)
    subnet_id = aws_subnet.private_subnets[count.index].id 
    route_table_id = aws_default_route_table.private_route.id
   // route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "public_route" {
    count = length(aws_subnet.public_subnets)
    subnet_id = aws_subnet.public_subnets[count.index].id    
    route_table_id = aws_route_table.public_route.id
}

