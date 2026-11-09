# Banco PostgreSQL de um serviço

Este módulo cria somente um banco em um Flexible Server existente; não cria,
altera ou transfere o servidor. Cada serviço deve instanciar o módulo em seu
próprio state, fixando a revisão do repositório e fornecendo `server_id` e
`database_name`. O provisionamento de usuários, grants e credenciais de runtime
e migrations é uma etapa separada e ainda deve ser implementada e validada.
