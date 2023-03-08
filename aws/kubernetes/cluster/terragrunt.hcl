include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr://${include.root.locals.kubernetes.cluster.source}//.?version=${include.root.locals.kubernetes.cluster.version}"
}

dependency "vpc" {
  config_path = "${get_repo_root()}/aws/network/vpc"
}

inputs = {
  stack                  = include.root.locals.stack
  vpc_id                 = dependency.vpc.outputs.vpc_id
  public_subnet_ids      = toset(dependency.vpc.outputs.public_subnet_ids)
  private_subnet_ids     = dependency.vpc.outputs.private_subnet_ids
  intra_subnet_ids       = dependency.vpc.outputs.intra_subnet_ids
  instance_type          = "t3.small"
  nodegroup_max_size     = 20
  nodegroup_min_size     = 3
  nodegroup_desired_size = 5
}
