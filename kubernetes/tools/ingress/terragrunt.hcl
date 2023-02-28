locals {
  env = read_terragrunt_config("${get_repo_root()}/${get_env("PROVIDER")}_env.hcl")
}

terraform {
  source = "${local.env.locals.kubernetes.ingress.source}//.?version=${local.env.locals.kubernetes.ingress.version}"
}

dependencies {
  paths = [
    "${get_repo_root()}/kubernetes/cluster",
    "${get_repo_root()}/network/zone",
    "${get_repo_root()}/network/certificate_import"
  ]
}

include {
  path = find_in_parent_folders()
}

inputs = {
  stack  = local.env.locals.stack
  domain = local.env.locals.domain
}
