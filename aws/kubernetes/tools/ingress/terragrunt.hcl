include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "tfr://${include.root.locals.kubernetes.tools.ingress.source}//.?version=${include.root.locals.kubernetes.tools.ingress.version}"
}

dependency "cluster" {
  config_path = "${get_repo_root()}/aws/kubernetes/cluster"
}

dependency "certificate" {
  config_path = "${get_repo_root()}/aws/network/certificate_import"
}

inputs = {
  stack              = include.root.locals.stack
  cluster_name       = dependency.cluster.outputs.cluster_name
  certificate_arn    = dependency.certificate.outputs.certificate_arn
  nginx_ingress_kind = "Deployment"
}
