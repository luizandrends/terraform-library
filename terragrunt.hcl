remote_state {
  backend = "s3"
  config = {
    bucket         = "library-tf-state-371565184611"
    key            = "terraform-library/${path_relative_to_include()}"
    region         = "us-east-1"
    encrypt        = true
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}