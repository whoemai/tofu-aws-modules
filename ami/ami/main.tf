resource "aws_ami" "ami" {
  name        = var.name
  description = var.description

  architecture        = var.architecture
  boot_mode           = var.boot_mode
  deprecation_time    = var.deprecation_time
  ena_support         = var.ena_support
  image_location      = var.image_location
  imds_support        = var.imds_support
  kernel_id           = var.kernel_id
  ramdisk_id          = var.ramdisk_id
  region              = var.region
  root_device_name    = var.root_device_name
  sriov_net_support   = var.sriov_net_support
  tpm_support         = var.tpm_support
  uefi_data           = var.uefi_data
  virtualization_type = var.virtualization_type

  dynamic "ebs_block_device" {
    for_each = var.ebs_block_devices

    content {
      device_name           = ebs_block_device.value.device_name
      delete_on_termination = ebs_block_device.value.delete_on_termination
      encrypted             = ebs_block_device.value.encrypted
      iops                  = ebs_block_device.value.iops
      outpost_arn           = ebs_block_device.value.outpost_arn
      snapshot_id           = ebs_block_device.value.snapshot_id
      throughput            = ebs_block_device.value.throughput
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
    }
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_devices

    content {
      device_name  = ephemeral_block_device.value.device_name
      virtual_name = ephemeral_block_device.value.virtual_name
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]

    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }

  tags = var.tags
}
