# VPC endpoint module

Creates an AWS VPC endpoint (`aws_vpc_endpoint`) of type `Interface` (PrivateLink, one ENI per subnet) or `Gateway` (S3 and DynamoDB, works by route).

## Example (Terraform, Interface)

```hcl
module "ecr_api_endpoint" {
  source = "git::https://github.com/whoemai/tofu-aws-modules.git//vpc/endpoint"

  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-2.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  security_group_ids = [aws_security_group.endpoints.id]

  tags = {
    Name = "ecr-api"
  }
}
```

## Example (Terraform, Gateway)

```hcl
module "s3_endpoint" {
  source = "git::https://github.com/whoemai/tofu-aws-modules.git//vpc/endpoint"

  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.us-east-2.s3"
  vpc_endpoint_type   = "Gateway"
  private_dns_enabled = false

  route_table_ids = [aws_route_table.private_a.id, aws_route_table.private_b.id]

  tags = {
    Name = "s3"
  }
}
```

## Example (Terragrunt, Gateway)

```hcl
terraform {
  source = "git::https://github.com/whoemai/tofu-aws-modules.git//vpc/endpoint"
}

inputs = {
  vpc_id              = "vpc-xxxxxxxx"
  service_name        = "com.amazonaws.us-east-2.s3"
  vpc_endpoint_type   = "Gateway"
  private_dns_enabled = false

  route_table_ids = [
    "rtb-aaaaaaa",
    "rtb-bbbbbbb"
  ]

  tags = {
    Name = "s3"
  }
}
```

## Inputs by endpoint type

| Input | Interface | Gateway | Notes |
|---|---|---|---|
| `vpc_id`, `service_name`, `tags` | yes | yes | |
| `vpc_endpoint_type` | `Interface` (default) | `Gateway` | |
| `subnet_ids` | yes | no | Leave `null` for Gateway. |
| `security_group_ids` | yes | no | Leave `null` for Gateway. |
| `private_dns_enabled` | yes (default `true`) | no | Gateway does not support it: pass `false`. |
| `route_table_ids` | no | yes | A route to the service prefix list is added to each route table. |
| `policy` | some services | yes | JSON. `null` keeps the AWS default (full access). |
| `service_region` | yes | no | Only for cross-region PrivateLink; `null` keeps same-region behavior. |

## Outputs

| Output | Description |
|---|---|
| `id` | The ID of the endpoint. |
| `arn` | Amazon Resource Name (ARN) of the endpoint. |
