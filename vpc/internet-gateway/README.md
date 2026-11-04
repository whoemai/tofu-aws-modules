# Internet Gateway module

Creates an AWS Internet Gateway and attaches it to a VPC.

## Example (Terraform)

```hcl
module "internet_gateway" {
  source = "git::git@bitbucket.org:CIonline/opentofu-aws-modules.git//vpc/internet-gateway"

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}
```

## Example (Terragrunt)

```hcl
terraform {
  source = "git::git@bitbucket.org:CIonline/opentofu-aws-modules.git//vpc/internet-gateway"
}

inputs = {
  vpc_id = "vpc-xxxxxxxx"

  tags = {
    Name = "main-igw"
  }
}
```

## Inputs

- `vpc_id` (string, required): VPC ID to attach the Internet Gateway.
- `tags` (map(string), required): Resource tags.

## Outputs

- `id`: Internet Gateway ID.
