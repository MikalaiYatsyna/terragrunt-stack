include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr://${include.root.locals.kubernetes.tools.consul.source}//.?version=${include.root.locals.kubernetes.tools.consul.version}"
}

dependency "zone" {
  config_path  = "${get_repo_root()}/aws/network/zone"
  skip_outputs = true
}

dependency "kubernetes_cluster" {
  config_path = "${get_repo_root()}/aws/kubernetes/cluster"
}

dependency "tooling_namespace" {
  config_path = "${get_repo_root()}/aws/kubernetes/namespace/tooling"
}

dependency "ingress" {
  config_path = "${get_repo_root()}/aws/kubernetes/tools/ingress"
}

inputs = {
  app_name          = include.root.locals.consul_app_name
  stack             = include.root.locals.stack
  domain            = include.root.locals.domain
  cluster_name      = dependency.kubernetes_cluster.outputs.cluster_name
  oidc_provider_arn = dependency.kubernetes_cluster.outputs.oidc_provider_arn
  tooling_namespace = dependency.tooling_namespace.outputs.name
  lb_arn            = dependency.ingress.outputs.lb_arn
}
