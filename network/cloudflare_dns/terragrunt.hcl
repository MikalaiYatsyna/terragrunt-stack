locals {
  env = read_terragrunt_config("${get_repo_root()}/${get_env("PROVIDER")}_env.hcl")
}

terraform {
  source = "${local.env.locals.network.cloudflare_dns_record.source}//.?version=${local.env.locals.network.cloudflare_dns_record.version}"
}

dependency "zone" {
  config_path = "${get_repo_root()}/network/zone"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  domain      = local.env.locals.domain
  root_domain = local.env.locals.root_domain
  records = {
    NS = toset(dependency.zone.outputs.nameservers)
  }
}
