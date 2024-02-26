remote_state {
  backend = "s3"
  config = {
    bucket         = "131328494269-terraform-state"
    # dynamodb_table = "library-state-table-035267315123"
    key            = "terraform-library/${path_relative_to_include()}"
    region         = "us-east-1"
    encrypt        = true
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}