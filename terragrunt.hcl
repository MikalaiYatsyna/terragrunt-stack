locals {
  env   = read_terragrunt_config("${get_repo_root()}/${get_env("PROVIDER")}_env.hcl")
  stack = local.env.locals.stack
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
      terraform {
        backend "s3" {
          region         = "${get_env("AWS_REGION")}"
          bucket         = "mikalai-yatsyna-tf-state"
          key            = "${get_env("STACK")}/${path_relative_to_include()}.tfstate"
          dynamodb_table = "tf_state_lock"
          encrypt        = true
        }
      }
  EOF
}
