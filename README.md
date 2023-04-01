# Terragrunt
Terragrunt code for provisioning stack resources.
```
.
└── aws
    ├── kubernetes
    │   ├── cluster
    │   │   └── terragrunt.hcl
    │   ├── namespace
    │   │   └── core
    │   │       └── terragrunt.hcl
    │   └── tools
    │       ├── autoscaler
    │       │   └── terragrunt.hcl
    │       ├── cert_manager
    │       │   └── terragrunt.hcl
    │       ├── cert_manager_issuer
    │       │   └── terragrunt.hcl
    │       └── external_dns
    │           └── terragrunt.hcl
    ├── network
    │   ├── cloudflare_dns
    │   │   └── terragrunt.hcl
    │   ├── vpc
    │   │   └── terragrunt.hcl
    │   └── zone
    │       └── terragrunt.hcl
    └── terragrunt.hcl
```
