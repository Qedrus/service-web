# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Driss-VPC"
  }
}

# Subnets publics
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

# Subnets privés
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = "Private Subnet ${count.index + 1}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Driss-IGW"
  }
}

# Table de routage publique
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Public Route Table"
  }
}

# Route publique vers Internet
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id

  depends_on = [aws_internet_gateway.main] # Ajout explicite de la dépendance
}

# Association de la table de routage publique avec les subnets publics
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)

  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

# Si un ID de sous-réseau public pour la NAT Gateway est fourni, utiliser celui-ci
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id                                                              # Utilise l'ID de l'EIP nouvellement allouée
  subnet_id     = var.public_subnet_id != "" ? var.public_subnet_id : aws_subnet.public[0].id # Utilisation du subnet public spécifié ou du premier subnet public

  tags = {
    Name = "Driss-NAT-Gateway"
  }
}

# Allouer une Elastic IP pour la NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc" # Associe cette EIP au VPC

  tags = {
    Name = "Driss-NAT-EIP"
  }
}

# Table de routage privée
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Private Route Table"
  }
}

# Route pour les sous-réseaux privés (Accès Internet via la NAT Gateway)
resource "aws_route" "private_nat_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id # Utilisation de la NAT Gateway nouvellement créée
}

# Association de la table de routage privée avec les sous-réseaux privés
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private[0].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private[1].id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Security group for public subnet"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permet l'accès HTTP de n'importe où
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Permet l'accès HTTPS de n'importe où
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Autorise tout le trafic sortant
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public SG"
  }
}
resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Security group for private subnet"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Autorise l'accès HTTP uniquement depuis le VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Permet tout le trafic sortant (vers Internet via la NAT Gateway)
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private SG"
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "RDS Subnet Group"
  }
}
