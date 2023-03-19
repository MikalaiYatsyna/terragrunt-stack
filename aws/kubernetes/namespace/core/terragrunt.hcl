include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr://${include.root.locals.kubernetes.namespace.source}//.?version=${include.root.locals.kubernetes.namespace.version}"
}

dependency "cluster" {
  config_path = "${get_repo_root()}/aws/kubernetes/cluster"
}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

inputs = {
  cluster_name   = dependency.cluster.outputs.cluster_name
  namespace_name = "core"
}
