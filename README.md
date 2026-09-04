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
