terraform {
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "6.40.0"
      }
    }

#     backend "s3" {
#       bucket         = "mojasim-remote-s3-bucket"
#       dynamodb_table = "remote-backend-db"
#       key            = "terraform.tfstate"
#       region         = "ap-south-1"
#       use_lockfile = true
#     }
}