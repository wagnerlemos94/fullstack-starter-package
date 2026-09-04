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
  -Nome "Gestao Escolar" `
  -Descricao "Sistema para administracao escolar" `
  -PacoteJava "br.com.digidatasistemas.gestaoescolar" `
  -GrupoMaven "br.com.digidatasistemas" `
  -Destino "E:\projetos\gestao-escolar" `
  -NaoInterativo
```

O script cria uma nova pasta e preserva este starter. Ele atualiza:

- nomes dos pacotes npm e Maven;
- nome e descricao das aplicacoes;
- pacote Java, imports e arvore de diretorios;
- classe principal e classe de teste;
- nome padrao sugerido para o banco;
- documentacao README e OpenAPI.

O destino precisa ser uma pasta nova, fora deste starter pack. Se `-Destino` for omitido, o projeto sera criado ao lado do starter usando o nome normalizado (por exemplo, `Gestao Escolar` vira `gestao-escolar`).
