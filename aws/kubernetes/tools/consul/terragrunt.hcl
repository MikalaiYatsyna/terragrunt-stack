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

dependency "core_namespace" {
  config_path = "${get_repo_root()}/aws/kubernetes/namespace/core"
}

dependency "ingress" {
  config_path  = "${get_repo_root()}/aws/kubernetes/tools/ingress"
  skip_outputs = true
}

dependency "cert_manager_issuer" {
  config_path = "${get_repo_root()}/aws/kubernetes/tools/cert_manager_issuer"
}

dependency "vault" {
  config_path = "${get_repo_root()}/aws/kubernetes/tools/vault"
}

dependency "vault_secret_backends" {
  config_path = "${get_repo_root()}/aws/kubernetes/tools/vault_config/secret_backends"
}

dependency "vault_k8s_auth" {
  config_path = "${get_repo_root()}/aws/kubernetes/tools/vault_config/k8s-auth"
}

dependency "external_dns" {
  config_path  = "${get_repo_root()}/aws/kubernetes/tools/external_dns"
  skip_outputs = true
}

inputs = {
  stack                    = include.root.locals.stack
  cluster_name             = dependency.kubernetes_cluster.outputs.cluster_name
  namespace                = dependency.core_namespace.outputs.name
  domain                   = include.root.locals.domain
  oidc_provider_arn        = dependency.kubernetes_cluster.outputs.oidc_provider_arn
  certificate_issuer       = dependency.cert_manager_issuer.outputs.letsencrypt_issuer
  vault_address            = dependency.vault.outputs.vault_address
  vault_token_secret_id    = dependency.vault.outputs.vault_token_secret_id
  vault_k8s_path           = dependency.vault_k8s_auth.outputs.backend_path
  vault_server_cert_secret = dependency.vault.outputs.vault_server_cert_secret_name
  pki_backend              = dependency.vault_secret_backends.outputs.backend["pki"]
  kv_backend               = dependency.vault_secret_backends.outputs.backend["kv-v2"]
}
