include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr://${include.root.locals.network.vpc.source}//.?version=${include.root.locals.network.vpc.version}"
}

inputs = {
  stack = include.root.locals.stack
}
