locals {
  env = read_terragrunt_config("${get_repo_root()}/${get_env("PROVIDER")}_env.hcl")
}

terraform {
  source = "${local.env.locals.network.vpc.source}//.?version=${local.env.locals.network.vpc.version}"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  stack               = local.env.locals.stack
  public_subnet_tags  = local.env.locals.network.vpc.inputs.public_subnet_tags
  private_subnet_tags = local.env.locals.network.vpc.inputs.private_subnet_tags
  intra_subnet_tags   = local.env.locals.network.vpc.inputs.intra_subnet_tags
}
