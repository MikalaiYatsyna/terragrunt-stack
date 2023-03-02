include {
  path = find_in_parent_folders()
}

terraform {
  source = "."
}

dependency "cloudflare_ca" {
  config_path = "${get_repo_root()}/aws/network/cloudflare_origin_ca"
}

generate "cert" {
  path      = "cert.pem"
  if_exists = "overwrite_terragrunt"
  contents  = dependency.cloudflare_ca.outputs.certificate_body
}

generate "key" {
  path      = "key.pem"
  if_exists = "overwrite_terragrunt"
  contents  = dependency.cloudflare_ca.outputs.private_key
}

generate "resource" {
  path      = "main.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
      resource "aws_acm_certificate" "cert" {
        certificate_body = file("cert.pem")
        private_key      = file("key.pem")
      }

      output "certificate_arn" {
        value = aws_acm_certificate.cert.arn
      }
  EOF
}
