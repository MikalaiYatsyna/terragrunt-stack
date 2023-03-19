include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr://${include.root.locals.kubernetes.tools.vault_k8s.source}//.?version=${include.root.locals.kubernetes.tools.vault_k8s.version}"
}

dependency "vault" {
  config_path = "${get_repo_root()}/aws/kubernetes/tools/vault"
}

dependency "kubernetes_cluster" {
  config_path = "${get_repo_root()}/aws/kubernetes/cluster"
}

dependency "core_namespace" {
  config_path = "${get_repo_root()}/aws/kubernetes/namespace/core"
}

inputs = {
  vault_address         = dependency.vault.outputs.vault_address
  vault_sa              = dependency.vault.outputs.vault_sa
  cluster_name          = dependency.kubernetes_cluster.outputs.cluster_name
  namespace             = dependency.core_namespace.outputs.name
  vault_token_secret_id = dependency.vault.outputs.vault_token_secret_id
}
