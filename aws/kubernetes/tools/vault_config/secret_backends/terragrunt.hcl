include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr://${include.root.locals.kubernetes.tools.vault_backends.source}//.?version=${include.root.locals.kubernetes.tools.vault_backends.version}"
}

dependency "vault" {
  config_path = "${get_repo_root()}/aws/kubernetes/tools/vault"
}

inputs = {
  vault_address         = dependency.vault.outputs.vault_address
  vault_token_secret_id = dependency.vault.outputs.vault_token_secret_id
}
