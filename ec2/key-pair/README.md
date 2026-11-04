# EC2 Key Pair Module

Imports an existing SSH public key as an EC2 key pair. The key is generated outside
Terraform (e.g. `ssh-keygen -t ed25519`) and only the public half is passed in, so the
private key never ends up in state — unlike generating it with `tls_private_key`.

## Requirements

- OpenTofu >= 1.0
- Provider: hashicorp/aws >= 4.0

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| key_name | Name of the EC2 key pair | string | - | yes |
| public_key | Public key material in OpenSSH format (contents of the .pub file) | string | - | yes |
| tags | Tags to apply to the key pair | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| key_name | Name of the key pair — pass it to `ec2/ec2-instance` `key_name` |
| id | ID of the key pair |
| arn | ARN of the key pair |
| fingerprint | Fingerprint of the public key, as computed by AWS |

## Terragrunt example

```hcl
terraform {
  source = "git::https://github.com/whoemai/tofu-aws-modules.git//ec2/key-pair"
}

inputs = {
  key_name   = basename(get_terragrunt_dir())
  public_key = trimspace(file("${get_terragrunt_dir()}/${basename(get_terragrunt_dir())}.pub"))
}
```

## Notes

- Changing `public_key` replaces the key pair. Instances that already use it keep the old
  key in `authorized_keys` — EC2 only injects the key at first boot.
