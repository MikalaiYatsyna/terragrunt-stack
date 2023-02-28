locals {
  env = read_terragrunt_config("${get_repo_root()}/${get_env("PROVIDER")}_env.hcl")
}

terraform {
  source = "${local.env.locals.kubernetes.tools.consul.source}//.?version=${local.env.locals.kubernetes.tools.consul.version}"
}

dependency "zone" {
  config_path  = "${get_repo_root()}/network/zone"
  skip_outputs = true
}

dependency "kubernetes_cluster" {
  config_path = "${get_repo_root()}/kubernetes/cluster"
}

dependency "tooling_namespace" {
  config_path  = "${get_repo_root()}/kubernetes/namespace/tooling"
  skip_outputs = true
}

dependency "ingress" {
  config_path  = "${get_repo_root()}/kubernetes/tools/ingress"
  skip_outputs = true
}

include {
  path = find_in_parent_folders()
}

inputs = {
  stack             = local.env.locals.stack
  domain            = local.env.locals.domain
  app_name          = local.env.locals.kubernetes.tools.consul.inputs.app_name
  tooling_namespace = local.env.locals.kubernetes.namespace.tooling.inputs.name
  oidc_provider_arn = dependency.kubernetes_cluster.outputs.oidc_provider_arn
}
