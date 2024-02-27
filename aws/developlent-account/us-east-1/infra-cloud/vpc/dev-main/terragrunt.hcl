locals {
  default_tags = read_terragrunt_config(find_in_parent_folders("default-tags.hcl"))
  providers = read_terragrunt_config(find_in_parent_folders("providers.hcl"))
  application_tags = {
    application = "core-infra"
    additional_tags = {
      services_vpc = true
    }
    private_subnet_additional_tags = {
      services_subnet = true
      private_subnet  = true
    }
    public_subnet_additional_tags = {
      services_subnet = false
      private_subnet  = false
    }
  }
}

terraform {
  source = "git@github.com:luizandrends/terraform-modules.git//modules/vpc?ref=v1.23.2"
}

inputs = merge(local.default_tags.locals.default_tags, local.application_tags, {
  name = "dev-main"

  cidr = "10.0.0.0/16"

  private_subnets = [
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
    },
    {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
    }
  ]

  public_subnets = [
    {
      cidr_block        = "10.0.101.0/24"
      availability_zone = "us-east-1a"
    },
    {
      cidr_block        = "10.0.102.0/24"
      availability_zone = "us-east-1b"
    }
  ]
})

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate
