# soat-postgres-infra

Scaffold Terraform da infraestrutura PostgreSQL gerenciada da plataforma
SOAT. Nenhum banco, servidor, rede ou credencial Azure é criado nesta fase.

## Estrutura

- `versions.tf`: Terraform e provider Azure declarados para validação;
- `environments/hml` e `environments/prod`: pontos de entrada reservados;
- `.github/workflows/ci.yml`: validação sem backend remoto ou credenciais.

## Validação local

```bash
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

O repositório não possui Dockerfile, pois entrega infraestrutura como código e
não uma aplicação executável. PostgreSQL Flexible Server, rede privada, TLS,
backups e usuários por ambiente serão implementados na Fase 3.

## Variáveis, arquitetura e CI

Não há variáveis Terraform nem arquivos `.tfvars` nesta fase; eles serão
adicionados na Fase 3 e permanecerão fora do Git. Consulte o
[diagrama central](https://github.com/JoaoGW/soat-api/blob/main/docs/architecture/README.md#mapa-de-responsabilidades-dos-repositórios).
O [workflow CI](https://github.com/JoaoGW/soat-postgres-infra/actions/workflows/ci.yml)
executa formatação e validação Terraform em `main` e `development`.
