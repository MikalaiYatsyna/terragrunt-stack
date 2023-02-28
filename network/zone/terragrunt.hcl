locals {
  env = read_terragrunt_config("${get_repo_root()}/${get_env("PROVIDER")}_env.hcl")
}

terraform {
  source = "${local.env.locals.network.zone.source}//.?version=${local.env.locals.network.zone.version}"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  domain = local.env.locals.domain
}
