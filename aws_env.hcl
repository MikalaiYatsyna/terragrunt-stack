locals {
  stack       = get_env("STACK")
  root_domain = get_env("ROOT_DOMAIN")
  domain      = "${local.stack}.${local.root_domain}"

  public_subnet_tags = merge({
    stack = local.stack,
    type  = "public"
  })
  private_subnet_tags = merge({
    stack = local.stack,
    type  = "private"
  })
  intra_subnet_tags = merge({
    stack = local.stack,
    type  = "intra"
  })

  kubernetes = {
    cluster = {
      source  = "tfr://app.terraform.io/logistic/eks/aws"
      version = "0.0.4"
      inputs = {
        instance_type       = "t3.micro"
        nodegroup_max_size  = 20
        public_subnet_tags  = local.public_subnet_tags
        private_subnet_tags = local.private_subnet_tags
        intra_subnet_tags   = local.intra_subnet_tags
      }
    }
    namespace = {
      source  = "tfr://app.terraform.io/logistic/eks-ns/aws"
      version = "0.0.1"
      tooling = {
        inputs = {
          name = "tooling"
        }
      }
    }
    ingress = {
      source  = "tfr://app.terraform.io/logistic/eks-ingress/aws"
      version = "0.0.3"
    }
    tools = {
      consul = {
        source  = "tfr://app.terraform.io/logistic/consul/aws"
        version = "0.0.3"
        inputs = {
          app_name       = "consul"
          create_ingress = true
        }
      }
      vault = {
        source  = "tfr://app.terraform.io/logistic/vault/aws"
        version = "0.0.3"
        inputs = {
          app_name       = "vault"
          create_ingress = true
        }
      }
      autoscaler = {
        source  = "tfr:///lablabs/eks-cluster-autoscaler/aws"
        version = "2.0.0"
      }
    }
  }

  network = {
    vpc = {
      source  = "tfr://app.terraform.io/logistic/vpc/aws"
      version = "0.0.2"
      inputs = {
        public_subnet_tags  = local.public_subnet_tags
        private_subnet_tags = local.private_subnet_tags
        intra_subnet_tags   = local.intra_subnet_tags
      }
    }
    zone = {
      source  = "tfr://app.terraform.io/logistic/route53/aws"
      version = "0.0.1"
    }
    cloudflare_dns_record = {
      source  = "tfr://app.terraform.io/logistic/dns-records/cloudflare"
      version = "0.0.2"
    }
    cloudflare_origin_ca = {
      source  = "tfr://app.terraform.io/logistic/origin-ca/cloudflare"
      version = "0.0.1"
    }
  }
}
