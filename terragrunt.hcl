locals {
  env    = read_terragrunt_config("${get_repo_root()}/${get_env("PROVIDER")}_env.hcl")
  stack  = local.env.locals.stack
  region = get_env("AWS_REGION")
}

remote_state {
  backend = "s3"
  config = {
    region         = local.region
    bucket         = "mikalai-yatsyna-tf-state"
    key            = "${local.stack}/${path_relative_to_include()}.tfstate"
    dynamodb_table = "tf_state_lock"
    encrypt        = true
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
