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
  source = "git@github.com:luizandrends/terraform-modules.git//modules/loadbalancer?ref=v1.21.0"
}

dependency "create_users_lambda" {
  config_path = "../../lambda/create-users"
}

inputs = merge(local.default_tags.locals.default_tags, local.application_tags, {
  name = "create-users"

  load_balancer_type         = "application"
  enable_deletion_protection = false

  sg_rules = [
    {
      from_port   = "0",
      to_port     = "65535",
      protocol    = "all",
      cidr_block  = "163.116.233.63/32",
      type        = "ingress",
      description = "Allow ingress to all protocols in all ports",
    }
  ]

  lambda_subscriptions = [
    {
      sid        = "allowlbaccess"
      lambda_arn = dependency.create_users_lambda.outputs.lambda_function_arn
      port       = "80"
      protocol   = "HTTP"
    },
  ]
})

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate