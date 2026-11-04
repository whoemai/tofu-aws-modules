# ssm-parameters

Cria parâmetros no SSM Parameter Store, separando os que são segredo (placeholder, nunca atualizados pelo Terraform) dos que são configuração gerida normalmente pelo Terraform.

Preencher, rotacionar e auditar valor real: [`documentos/RUNBOOK-segredos.md`](../../documentos/RUNBOOK-segredos.md).

## Uso

```hcl
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../ssm/parameters"
}

inputs = {
  parameters = {
    "/prod/app/db/password" = {
      type = "SecureString"
    }
  }

  managed_parameters = {
    "/prod/app/db/endpoint" = {
      type  = "String"
      value = "app-db.cluster-xxxx.us-east-1.rds.amazonaws.com"
    }
  }

  tags = {
    Ambiente = "projeto"
  }
}
```

## Inputs

| Nome | Tipo | Obrigatório | Default | Descrição |
|---|---|---|---|---|
| `parameters` | `map(object({ type, description, tier }))` | Não | `{}` | Parâmetros SEGREDO — nascem com placeholder e o Terraform nunca mais toca no recurso (`ignore_changes = all`). Chave = path completo. |
| `managed_parameters` | `map(object({ type, value, description, tier }))` | Não | `{}` | Parâmetros de CONFIGURAÇÃO não sensível — valor gerido pelo Terraform normalmente, sem `ignore_changes`. |
| `placeholder_prefix` | `string` | Não | `"PREENCHER-FORA-DO-TERRAFORM"` | Prefixo do valor inicial dos parâmetros de `parameters`. O valor final é `<prefixo>-<24 chars aleatórios>`. |
| `tags` | `map(string)` | Não | `{}` | Tags aplicadas a todos os parâmetros (segredo + gerido). |

## Outputs

| Nome | Descrição |
|---|---|
| `parameter_names` | Paths de todos os parâmetros criados, segredo + gerido. |
| `parameter_arns` | ARNs por path — referência pras policies IRSA por app (`iam/irsa-app`). |
| `secret_parameter_names` | Paths dos parâmetros de SEGREDO — a superfície que precisa de valor real em algum momento. |

## O placeholder é prefixo + aleatório, não uma constante

Um placeholder de segredo tem duas funções conflitantes: sinalizar "vazio" (para isso precisa ser reconhecível) e ocupar o campo de uma credencial (para isso um sistema vai aceitá-lo). Enquanto ele foi uma constante fixa declarada como default aqui, ele era as duas coisas **e** estava versionado no GitHub — bastou um seed de banco ler esse valor e rodar `CREATE USER` com ele pra que o placeholder se tornasse a senha real e pública de um usuário MySQL.

O valor agora é `<placeholder_prefix>-<24 chars aleatórios>` (`random_password` por path):

- `grep PREENCHER-FORA-DO-TERRAFORM` num log de app continua funcionando — o sinal não se perdeu;
- o valor não existe fora do Terraform state, então usá-lo por acidente não publica credencial nenhuma;
- e `scripts/segredos.sh` distingue os dois formatos, o que dá um inventário de "quem nunca foi preenchido" e um alarme pros paths que ainda estão com a constante antiga.

`special = false` no gerador é deliberado: se este valor acabar usado como senha — o cenário contra o qual ele existe — caractere especial numa URL de JDBC ou num arquivo de properties troca um "Access denied" legível por um erro de parse a três camadas de distância.

## `ignore_changes = all` no recurso de segredo, e não `[value]`

`ignore_changes` impede o Terraform de **ver** a mudança de valor, não de **causar**. O que está no state continua sendo o placeholder do create, e o provider AWS envia `Value` em todo `PutParameter` de update — inclusive num update disparado só por `description` ou `tier`. Com `[value]`, editar a descrição de um path já preenchido reescreve o segredo de volta pro placeholder: o app cai em `Access denied` num apply cujo plan não mencionou senha alguma.

Com `all`, o Terraform só cria e destrói esse recurso. Consequências que valem saber:

- alterar `description`/`tier`/`type`/`tags` de um path de segredo é **no-op silencioso** no plan. Pra mudar de verdade, é preciso recriar o path — o que **apaga o valor**, então só em path ainda não preenchido (confira antes com `bash scripts/segredos.sh status`);
- as policies de leitura desta conta escopam por path, não por tag. Se isso mudar, a tag precisa passar a ser gerenciada em outro lugar — não relaxando este `lifecycle`.

## Notas

- `parameters` e `managed_parameters` viram dois `resource` distintos (`aws_ssm_parameter.secret` e `.managed`), não um só com `for_each` condicional — `ignore_changes` é estático em HCL, então só um recurso sem ele permite ao Terraform atualizar configuração não sensível sem abrir mão de nunca sobrescrever segredo.
- O output `pending_fill` foi substituído por `secret_parameter_names`. Ele prometia mais do que podia entregar: como o Terraform não vê o valor, a lista era idêntica à de todos os segredos e continuava afirmando "falta preencher" mesmo depois de tudo preenchido. "Está preenchido?" só se responde olhando o valor na AWS — `bash scripts/segredos.sh status`.
- Nenhuma variável é obrigatória (todas têm default), mas chamar o módulo sem preencher `parameters`/`managed_parameters` não cria nada — o exemplo de uso acima é o mínimo que faz sentido na prática, não o mínimo sintático.
