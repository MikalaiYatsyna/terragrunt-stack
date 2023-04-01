include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr://${include.root.locals.github.gitops_repo.source}//.?version=${include.root.locals.github.gitops_repo.version}"
}

inputs = {
  stack = include.root.locals.stack
}
