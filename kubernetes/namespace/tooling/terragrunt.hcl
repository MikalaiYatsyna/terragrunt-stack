locals {
  env = read_terragrunt_config("${get_repo_root()}/${get_env("PROVIDER")}_env.hcl")
}

terraform {
  source = "${local.env.locals.kubernetes.namespace.source}//.?version=${local.env.locals.kubernetes.namespace.version}"
}

dependencies {
  paths = ["${get_repo_root()}/kubernetes/cluster"]
}

include {
  path = find_in_parent_folders()
}

inputs = {
  stack          = local.env.locals.stack
  namespace_name = local.env.locals.kubernetes.namespace.tooling.inputs.name
}
