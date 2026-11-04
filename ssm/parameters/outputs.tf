output "parameter_names" {
  description = "Nomes (paths) de todos os parâmetros criados, segredo + gerido"
  value       = sort(concat(keys(aws_ssm_parameter.secret), keys(aws_ssm_parameter.managed)))
}

output "parameter_arns" {
  description = "ARNs por path — referência pras policies IRSA por app (iam/irsa-app)"
  value = merge(
    { for k, v in aws_ssm_parameter.secret : k => v.arn },
    { for k, v in aws_ssm_parameter.managed : k => v.arn },
  )
}

output "secret_parameter_names" {
  description = <<-EOT
    Paths de todos os parâmetros de SEGREDO — a superfície que precisa de valor real em
    algum momento. Serve de insumo pro `scripts/segredos.sh` e pro checklist do cofre
    (`documentos/RUNBOOK-segredos.md`).

    Substituiu o output `pending_fill`, que prometia mais do que podia entregar: como o
    Terraform não vê o valor (`ignore_changes`), aquela lista era byte a byte igual a
    esta e continuava afirmando "falta preencher" mesmo depois de todo mundo preenchido.
    "Está preenchido?" só se responde olhando o valor na AWS — `scripts/segredos.sh
    status`.
  EOT
  value       = sort(keys(aws_ssm_parameter.secret))
}
