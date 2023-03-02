include "root" {
  path = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr://${include.root.locals.network.zone.source}//.?version=${include.root.locals.network.zone.version}"
}

dependency "cert_import" {
  config_path = "${get_repo_root()}/aws/network/certificate_import"
}

inputs = {
  domain = include.root.locals.domain
}
