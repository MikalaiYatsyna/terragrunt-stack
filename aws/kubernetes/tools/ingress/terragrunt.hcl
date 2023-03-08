include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr://${include.root.locals.kubernetes.tools.ingress.source}//.?version=${include.root.locals.kubernetes.tools.ingress.version}"
}

dependency "cluster" {
  config_path = "${get_repo_root()}/aws/kubernetes/cluster"
}

dependency "tooling_namespace" {
  config_path = "${get_repo_root()}/aws/kubernetes/namespace/tooling"
}

inputs = {
  stack              = include.root.locals.stack
  cluster_name       = dependency.cluster.outputs.cluster_name
  namespace          = dependency.tooling_namespace.outputs.name
  oidc_provider_arn  = dependency.cluster.outputs.oidc_provider_arn
  nginx_ingress_kind = "Deployment"
}
