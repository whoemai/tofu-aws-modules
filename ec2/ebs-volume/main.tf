resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone
  size              = var.size
  type              = var.type
  encrypted         = var.encrypted
  iops              = var.iops
  throughput        = var.throughput
  kms_key_id        = var.kms_key_id

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_volume_attachment" "this" {
  device_name                    = var.device_name
  volume_id                      = aws_ebs_volume.this.id
  instance_id                    = var.instance_id
  force_detach                   = var.force_detach
  stop_instance_before_detaching = var.stop_instance_before_detaching
}
