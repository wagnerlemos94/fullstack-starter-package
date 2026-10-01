# Starter Pack

Template full stack com backend Spring Boot e frontend Next.js.

## Criar um projeto

No PowerShell, execute o gerador interativo:

```powershell
.\criar-projeto.ps1
```

Ou informe tudo pela linha de comando:

```powershell
.\criar-projeto.ps1 `
  -Nome "Meu Projeto" `
  -Descricao "Descricao do meu projeto" `
  -PacoteJava "br.com.empresa.meuprojeto" `
  -GrupoMaven "br.com.empresa" `
  -Destino "C:\projetos\meu-projeto" `
  -NaoInterativo
```

O script cria uma nova pasta e preserva este starter. Ele atualiza:

- nomes dos pacotes npm e Maven;
- nome e descricao das aplicacoes;
- pacote Java, imports e arvore de diretorios;
- classe principal e classe de teste;
- nome padrao sugerido para o banco;
- documentacao README e OpenAPI.

O destino precisa ser uma pasta nova, fora deste starter pack. Se `-Destino` for omitido, o projeto sera criado ao lado do starter usando o nome normalizado (por exemplo, `Meu Projeto` vira `meu-projeto`).
## Repositórios e documentação

- [Backend Spring Boot](https://github.com/wagnerlemos94/starter-package-api): configuração, autenticação e contrato REST no [README do backend](backend/README.md).
- [Frontend Next.js](https://github.com/wagnerlemos94/starter-package-app): execução, sessão NextAuth e integração no [README do frontend](frontend/README.md).

O projeto raiz registra as referências Git dos repositórios `backend` e `frontend`. Publique os commits desses repositórios antes de atualizar as referências no projeto raiz. Cada repositório mantém seu próprio histórico e remoto.

## Contrato de paginação

O backend usa `crud-core` 2.0.0 e recebe `page` (começando em zero) e `size` nas listagens. A resposta contém `content`, `page`, `size`, `totalElements` e `totalPages`.

O frontend mantém `ApiResult<PageResponse<T>>` nos métodos `list`, com parâmetros opcionais e padrão `{ page: 0, size: 10 }`. As tabelas de usuários e perfis usam paginação do servidor; os formulários carregam uma única página de 20 opções. Consultas completas sem paginação devem ser implementadas por caso específico.
