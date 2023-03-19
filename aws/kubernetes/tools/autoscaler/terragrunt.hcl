include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr://${include.root.locals.kubernetes.tools.autoscaler.source}//.?version=${include.root.locals.kubernetes.tools.autoscaler.version}"
}

dependency "cluster" {
  config_path = "${get_repo_root()}/aws/kubernetes/cluster"
}

inputs = {
  cluster_name                     = dependency.cluster.outputs.cluster_name
  cluster_identity_oidc_issuer     = dependency.cluster.outputs.oidc_provider
  cluster_identity_oidc_issuer_arn = dependency.cluster.outputs.oidc_provider_arn
  namespace                        = "default"
}
