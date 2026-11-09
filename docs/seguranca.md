# Segurança do PostgreSQL

Cada ambiente cria um PostgreSQL Flexible Server 16 privado, com subnet
delegada, DNS privado, acesso público desabilitado, TLS obrigatório, backup de
sete dias e HA/geo-backup desabilitados por custo.

Os parâmetros `log_connections`, `log_disconnections`, `log_checkpoints` e
`connection_throttle.enable` ficam habilitados. Os logs do servidor são
retidos por sete dias. A coleta centralizada de telemetria é responsabilidade
da Fase 6.

O `DATABASE_URL` é guardado exclusivamente no Key Vault, marcado como
`application/vnd.soat.database-url`; nenhum segredo é versionado no GitHub.

## Exceção de expiração do segredo

A exceção `AVD-AZU-0017` permanece até a Fase 5, quando o papel de aplicação e
o processo de rotação puderem ser implantados dentro da rede privada. Uma data
de expiração arbitrária agora faria a aplicação perder acesso ao banco sem
renovação automática. A senha inicial é gerada aleatoriamente pelo Terraform e
nunca é exibida em outputs ou logs.
