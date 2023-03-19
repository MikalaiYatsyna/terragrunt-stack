include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr://${include.root.locals.kubernetes.tools.cert_manager.source}//.?version=${include.root.locals.kubernetes.tools.cert_manager.version}"
}

dependency "kubernetes_cluster" {
  config_path = "${get_repo_root()}/aws/kubernetes/cluster"
}

inputs = {
  stack             = include.root.locals.stack
  cluster_name      = dependency.kubernetes_cluster.outputs.cluster_name
  domain            = include.root.locals.domain
  namespace         = "default"
  oidc_provider_arn = dependency.kubernetes_cluster.outputs.oidc_provider_arn
}
