locals {
    workspace_config = {
        dev = {
            instance_count = 1
            bucket_count = 1
        }

        stg = {
            instance_count = 1
            bucket_count = 1
        }

        prd = {
            instance_count = 1
            bucket_count = 1
        }

        default = {
            instance_count = 1
            bucket_count = 1
        }
    }
}

module "ec2" {
    source = "./modules/ec2"

    ec2_instance_count = lookup(local.workspace_config, terraform.workspace, local.workspace_config.default).instance_count
}

module "s3" {
    source = "./modules/s3"

    env = terraform.workspace

    bucket_count = lookup(local.workspace_config, terraform.workspace, local.workspace_config.default).bucket_count
}