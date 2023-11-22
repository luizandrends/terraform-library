remote_state {
  backend = "s3"
  config = {
    bucket         = "library-state-bucket-035267315123"
    dynamodb_table = "library-state-table-035267315123"
    key            = "terraform-library/${path_relative_to_include()}"
    region         = "us-east-1"
    encrypt        = true
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}