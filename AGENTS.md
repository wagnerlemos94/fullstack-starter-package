# Instruções do Starter Package

## Estrutura e fontes de referência

- Este é um template full stack: `backend/` usa Spring Boot e `frontend/` usa Next.js.
- A raiz, o backend e o frontend têm históricos e remotos Git próprios. A raiz registra os commits dos dois repositórios como gitlinks.
- Leia o `AGENTS.md` do diretório afetado antes de alterar código. Consulte os READMEs para configuração e execução; os contratos efetivos devem ser conferidos no código.
- Use `criar-projeto.ps1` como referência para mudanças no gerador. Preserve a possibilidade de renomear o projeto, o pacote Java e a identidade das aplicações.

## Forma de trabalhar

- Faça a menor alteração que resolva a solicitação e siga os padrões existentes.
- Reutilize métodos, componentes e contratos. Use parâmetros opcionais quando isso ampliar um método existente sem mudar seu contrato de retorno.
- Crie serviços, helpers e outras abstrações apenas quando uma necessidade concreta justificar a nova camada. Não acrescente infraestrutura por antecipação.
- Preserve alterações existentes do usuário. Não inclua arquivos sem relação com a tarefa nos commits.
- Mudanças de contrato no backend exigem conferir os consumidores no frontend e ajustar a documentação relevante.
- Diferencie erros de implementação de testes desatualizados. Não enfraqueça testes ou remova cobertura apenas para obter um build verde.
- Documente decisões estáveis nestes arquivos; mantenha detalhes de uso nos READMEs, evitando duplicação extensa.

## Integração atual

- As listagens REST recebem `page` e `size` e retornam `content`, `page`, `size`, `totalElements` e `totalPages`. O índice da página começa em zero.
- O frontend preserva `ApiResult<T>`. As listagens retornam sempre `ApiResult<PageResponse<T>>`, independentemente dos parâmetros opcionais.
- As tabelas de usuários e perfis usam paginação do servidor. Os formulários consultam uma página de 20 opções, sem loops para carregar todas as páginas.
- Consultas completas sem paginação devem ser implementadas para o caso específico quando solicitadas.

## Validação e publicação

- Execute os checks proporcionais às mudanças, seguindo os comandos dos arquivos de cada projeto. Informe falhas e limitações na entrega.
- Para mudanças apenas em documentação, revise conteúdo, caminhos e `git diff --check`; não execute builds sem necessidade.
- Faça commit e push quando solicitados. Publique backend e/ou frontend primeiro; depois registre e publique suas referências na raiz.
- Confira branch, remoto e estado dos três repositórios. Não use force push nem inclua arquivos como `artifacts/` automaticamente.
- Não grave credenciais em código, documentação ou instruções.
