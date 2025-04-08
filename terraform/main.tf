terraform {
  backend "s3" {
    bucket = "web-service-bucket-terraform-s3" # le bucket créé plutôt appelé datascientest-bucket
    key    = "terraform.tfstate"               # le fichier dans le bucket qui sera garant de l'état de l'instructure
    region = "eu-west-3"                       # la région ou se trouve le bucket
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "~> 2.0"
    }

  }
  required_version = ">= 1.5.0"
}




provider "aws" {
  region = var.aws_region
  # access_key = var.aws_access_key
  # secret_key = var.aws_secret_key
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones   = ["eu-west-3a", "eu-west-3b"]
  vpc_id               = aws_vpc.main.id
}
module "keypair" {
  source           = "./modules/keypair"
  key_name         = "eks-keypair"
  public_key_path  = "~/.ssh/eks-keypair.pub"
  private_key_path = "~/.ssh/eks-keypair"
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  # Passer les variables nécessaires au module EKS
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnet_ids
  cluster_name       = "my-cluster"
  cluster_version    = "1.21"
  node_instance_type = "t3.medium"
  desired_capacity   = 2
  max_capacity       = 3
  min_capacity       = 1
  keypair_key_name   = module.keypair.key_name
}


module "iam" {
  source         = "./modules/iam"
  aws_account_id = "969799237091"
  iam_user       = "jan25_bootcamp_devops_services"
}

module "rds" {
  source               = "./modules/rds"
  db_name              = "wordpress_db"
  db_username          = "admin"
  db_password          = "Driss123!"
  db_subnet_group_name = module.vpc.db_subnet_group_name
  security_group_id    = module.vpc.rds_security_group_id
  allowed_ips          = ["0.0.0.0/0"]   # Exemple d'IP autorisée
  vpc_id               = aws_vpc.main.id # Passe l'ID de la VPC


}


module "s3" {
  source      = "./modules/s3"
  bucket_name = "s3-bucket-name-2025-driss" # Assure-toi que ce nom est unique
  environment = "dev"
}

data "aws_eks_cluster" "cluster" {
  name = "my-cluster"
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.name
}
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}


provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}



module "monitoring" {
  source = "./modules/monitoring"

  # Configuration obligatoire
  admin_password = var.grafana_admin_password # À remplacer par une variable sensible
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
  # Configurations optionnelles (valeurs par défaut déjà définies)
  # namespace     = "monitoring"
  # chart_version = "45.6.0"
  # release_name  = "kube-prometheus-stack"
  # repository    = "https://prometheus-community.github.io/helm-charts"
}

# Variables à ajouter dans variables.tf racine si nécessaire
variable "grafana_admin_password" {
  type        = string
  sensitive   = true
  description = "Mot de passe admin Grafana"
}


