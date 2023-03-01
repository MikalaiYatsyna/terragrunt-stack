locals {
  env = read_terragrunt_config("${get_repo_root()}/${get_env("PROVIDER")}_env.hcl")
}

terraform {
  source = "${local.env.locals.network.cloudflare_origin_ca.source}//.?version=${local.env.locals.network.cloudflare_origin_ca.version}"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  domain = local.env.locals.domain
}
