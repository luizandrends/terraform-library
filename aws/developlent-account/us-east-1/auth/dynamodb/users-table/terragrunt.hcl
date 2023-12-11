locals {
  default_tags = read_terragrunt_config(find_in_parent_folders("default-tags.hcl"))
  providers = read_terragrunt_config(find_in_parent_folders("providers.hcl"))
  application_tags = {
    application = "create-users"
  }
}

terraform {
  source = "git@github.com:luizandrends/terraform-modules.git//modules/dynamodb?ref=v1.21.0"
}

dependency "create_users_lambda" {
  config_path = "../../lambda/create-users"
}

inputs = merge(local.default_tags.locals.default_tags, local.application_tags, {
  name = "users-table"

  hash_key                    = "id"
  range_key                   = "email"
  table_class                 = "STANDARD"
  deletion_protection_enabled = false

  attributes = [
    {
      name = "id"
      type = "S"
    },
    {
      name = "name"
      type = "S"
    },
    {
      name = "email"
      type = "S"
    },
    {
      name = "password"
      type = "S"
    },
    {
      name = "created_at"
      type = "S"
    },
    {
      name = "updated_at"
      type = "S"
    }
  ]
})

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate