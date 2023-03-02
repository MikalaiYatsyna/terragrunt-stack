include "root" {
  path   = find_in_parent_folders()
  expose = true
}

dependency "cluster" {
  config_path = "${get_repo_root()}/aws/kubernetes/cluster"
}

terraform {
  source = "tfr://${include.root.locals.network.cloudflare_origin_ca.source}//.?version=${include.root.locals.network.cloudflare_origin_ca.version}"
}

inputs = {
  domain = include.root.locals.domain
}
