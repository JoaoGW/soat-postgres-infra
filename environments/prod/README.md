# Produção

Cria o Flexible Server privado de produção, o banco `oficina_prod` e grava o
segredo `database-url-prod` no Key Vault compartilhado. Usa `prod.tfstate` no
container de state PostgreSQL e só aplica após a trava de custo ser habilitada.
