resource "aws_sqs_queue" "sqs" {
  region      = var.region
  name        = var.name
  name_prefix = var.name_prefix

  content_based_deduplication       = var.content_based_deduplication
  deduplication_scope               = var.deduplication_scope
  delay_seconds                     = var.delay_seconds
  fifo_queue                        = var.fifo_queue
  fifo_throughput_limit             = var.fifo_throughput_limit
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  kms_master_key_id                 = var.kms_master_key_id
  max_message_size                  = var.max_message_size
  message_retention_seconds         = var.message_retention_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  sqs_managed_sse_enabled           = var.sqs_managed_sse_enabled
  visibility_timeout_seconds        = var.visibility_timeout_seconds

  tags = var.tags
}

# As três policies da fila saem em recursos separados: a documentação do provider prefere
# `aws_sqs_queue_policy`, `aws_sqs_queue_redrive_policy` e `aws_sqs_queue_redrive_allow_policy`
# aos argumentos `policy`, `redrive_policy` e `redrive_allow_policy` da própria fila.
resource "aws_sqs_queue_policy" "sqp" {
  count = var.policy != null ? 1 : 0

  region    = var.region
  queue_url = aws_sqs_queue.sqs.id
  policy    = var.policy
}

resource "aws_sqs_queue_redrive_policy" "rdp" {
  count = var.redrive_policy != null ? 1 : 0

  region         = var.region
  queue_url      = aws_sqs_queue.sqs.id
  redrive_policy = var.redrive_policy
}

resource "aws_sqs_queue_redrive_allow_policy" "rdap" {
  count = var.redrive_allow_policy != null ? 1 : 0

  region               = var.region
  queue_url            = aws_sqs_queue.sqs.id
  redrive_allow_policy = var.redrive_allow_policy
}
