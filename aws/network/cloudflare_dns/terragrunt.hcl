include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr://${include.root.locals.network.cloudflare_dns_record.source}//.?version=${include.root.locals.network.cloudflare_dns_record.version}"
}

dependency "zone" {
  config_path = "${get_parent_terragrunt_dir()}/network/zone"
}

inputs = {
  domain      = include.root.locals.domain
  root_domain = include.root.locals.root_domain
  records = {
    NS = toset(dependency.zone.outputs.nameservers)
  }
}
