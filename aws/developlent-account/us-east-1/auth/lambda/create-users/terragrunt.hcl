locals {
  default_tags = read_terragrunt_config(find_in_parent_folders("default-tags.hcl"))
  providers    = read_terragrunt_config(find_in_parent_folders("providers.hcl"))
  application_tags = {
    application = "create-users"
  }
}

terraform {
  source = "git@github.com:luizandrends/terraform-modules.git//modules/lambda?ref=v1.21.0"
}

dependency "dev_vpc" {
  config_path = "../../../infra-cloud/vpc/dev-main"
}

dependency "create_users_table" {
  config_path = "../../dynamodb/users-table"
}

inputs = merge(local.default_tags.locals.default_tags, local.application_tags, {
  name = "create-users"

  handler     = "dist/main/handler.handleRequest"
  memory_size = 128
  runtime     = "nodejs20.x"
  timeout     = 12

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

  policy = [
    {
      "sid" : "AllowDynamoDBCreateUsersAccess"
      "effect" : "Allow"
      "actions" : ["dynamodb:PutItem", "dynamodb:UpdateItem"]
      "resources" : [dependency.create_users_table.outputs.dynamodb_table_arn]
    }
  ]
})

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate