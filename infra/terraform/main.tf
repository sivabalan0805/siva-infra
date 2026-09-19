terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags { tags = { Environment = var.environment, Project = "siva-infra" } }
}

resource "aws_ecr_repository" "services" {
  for_each             = toset(["python-api", "java-api", "go-api"])
  name                 = "siva-infra/${var.environment}/${each.key}"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration { scan_on_push = true }
}

output "ecr_repositories" {
  value = { for name, repository in aws_ecr_repository.services : name => repository.repository_url }
}