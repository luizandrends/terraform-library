locals {
  default_tags = read_terragrunt_config(find_in_parent_folders("default-tags.hcl"))
  providers = read_terragrunt_config(find_in_parent_folders("providers.hcl"))
  application_tags = {
    application = "some-sandbox-lambda"
    additional_tags = {
      some-key = "some-value"
    }
  }
}

terraform {
  source = "git@github.com:luizandrends/terraform-modules.git//modules/lambda?ref=v1.21.0"
}

inputs = merge(local.default_tags.locals.default_tags, local.application_tags, {
  name = "create-users"

  handler     = "lambda_code/src/main/main"
  memory_size = 128
  runtime     = "go1.x"
  timeout     = 15

  sg_rules = [
    {
      from_port   = "0",
      to_port     = "65535",
      protocol    = "all",
      cidr_block  = "10.0.101.0/24",
      type        = "ingress",
      description = "Allow LB Traffic",
    },
    {
      from_port   = "0",
      to_port     = "65535",
      protocol    = "all",
      cidr_block  = "10.0.102.0/24",
      type        = "ingress",
      description = "Allow LB Traffic",
    },
    {
      from_port   = "0",
      to_port     = "65535",
      protocol    = "all",
      cidr_block  = "10.0.103.0/24",
      type        = "ingress",
      description = "Allow LB Traffic",
    }
  ]
})

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate