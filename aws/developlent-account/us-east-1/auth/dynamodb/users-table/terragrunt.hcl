locals {
  default_tags = read_terragrunt_config(find_in_parent_folders("default-tags.hcl"))
  providers    = read_terragrunt_config(find_in_parent_folders("providers.hcl"))
  application_tags = {
    application = "create-users"
  }
}

terraform {
  source = "git@github.com:luizandrends/terraform-modules.git//modules/dynamodb?ref=v1.21.0"
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

  global_secondary_indexes = [
    {
      name               = "NameIndex"
      hash_key           = "name"
      range_key          = "email"
      projection_type    = "INCLUDE"
      non_key_attributes = ["id"]
    },
    {
      name               = "EmailIndex"
      hash_key           = "email"
      range_key          = "name"
      projection_type    = "INCLUDE"
      non_key_attributes = ["id"]
    },
    {
      name               = "PasswordIndex"
      hash_key           = "password"
      range_key          = "email"
      projection_type    = "INCLUDE"
      non_key_attributes = ["id"]
    },
    {
      name               = "CreatedAtIndex"
      hash_key           = "created_at"
      range_key          = "email"
      projection_type    = "INCLUDE"
      non_key_attributes = ["id"]
    },
    {
      name               = "UpdatedAtIndex"
      hash_key           = "updated_at"
      range_key          = "email"
      projection_type    = "INCLUDE"
      non_key_attributes = ["id"]
    }
  ]

  
})

include {
  path = find_in_parent_folders()
}

generate = local.providers.generate



