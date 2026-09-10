# Homologação

Cria o Flexible Server privado de homologação, o banco `oficina_hml` e grava o
segredo `database-url-hml` no Key Vault compartilhado. Usa `hml.tfstate` no
container de state PostgreSQL e só aplica após a trava de custo ser habilitada.
