include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr://${include.root.locals.network.zone.source}//.?version=${include.root.locals.network.zone.version}"
}

inputs = {
  domain = include.root.locals.domain
}
