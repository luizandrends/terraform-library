locals {
  providers = read_terragrunt_config(find_in_parent_folders("providers.hcl"))
}

terraform {
  source = "git@github.com:luizandrends/terraform-modules.git//modules/route53/zone?ref=v1.23.0"
}

inputs =  {
  zones = {
    "dev-library.com" = {
      comment = "dev-library.com (dev env)"
      tags = {
        Name = "dev-library.com"
        application = "core-infra"
      }
    }
  }
}

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate