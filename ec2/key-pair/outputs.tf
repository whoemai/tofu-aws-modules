output "key_name" {
  description = "Name of the key pair (what ec2/ec2-instance key_name expects)"
  value       = aws_key_pair.this.key_name
}

output "id" {
  description = "ID of the key pair"
  value       = aws_key_pair.this.key_pair_id
}

output "arn" {
  description = "ARN of the key pair"
  value       = aws_key_pair.this.arn
}

output "fingerprint" {
  description = "Fingerprint of the public key, as computed by AWS"
  value       = aws_key_pair.this.fingerprint
}
