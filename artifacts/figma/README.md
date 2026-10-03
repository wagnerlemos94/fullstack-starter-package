# Protótipo do frontend

Arquivo: https://www.figma.com/design/GSRgciwk2FuhoWEvyfCPwm
Protótipo: https://www.figma.com/proto/GSRgciwk2FuhoWEvyfCPwm?node-id=4-2&starting-point-node-id=4%3A2

9 telas desktop, 1440 × 900: Login (4:2), Início (4:3), Usuários (4:4), Cadastro de usuário (4:5), Perfis (4:6), Cadastro de perfil (4:7), Exemplos (4:8), Cadastro de exemplo (4:9), Menu (4:10).
38 links criados: entrar, abrir menu, navegar entre módulos, novo, editar, salvar/cancelar e retorno ao login pelo nome do usuário.
Dados fictícios. Formulários e permissões são representações visuais; não salvam dados reais.
Roboto preservada; Arial substituída por Arimo devido à indisponibilidade no Figma.

## Pendências por limite da integração no plano Starter
- Remover o preenchimento roxo interno dos botões Material, preservando o azul-marinho/estilo secundário do frontend.
- Concluir revisão visual de todas as telas e auditoria dos links/fontes.
- Remover a captura de referência Document (3:2) após revisão final.
- Ajustar interações complementares (permissões, status, excluir, menu de conta) se necessário.

O script temporário de captura foi removido do frontend; _document.tsx não tem alterações desta tarefa.

## Atualização pendente — Dashboard (03/10/2026)

A página inicial agora contém o dashboard componentizado em `frontend/src/features/dashboard/components/`: cabeçalho com atualização, cards de totais/ativos/inativos, cadastros por categoria, distribuição por status e atalhos por permissão. A consulta está em `useDashboard.ts` e usa `GET /dashboard` com `DASHBOARD:VIEW`.

Atualizar a tela Início (4:3), preservando seu ID e os links existentes do protótipo. Em desktop, usar três colunas iguais com intervalo de 20 px: o painel de categorias ocupa duas colunas e o painel de distribuição ocupa a terceira, alinhado ao card de inativos acima. Em celular, empilhar os cards. Usar textos, cores e espaçamentos dos componentes atuais; os valores numéricos no protótipo devem ser identificados como dados de exemplo. Representar carregamento, erro com tentativa novamente, ausência de dados e falta de permissão.

Em 03/10/2026, a integração conseguiu listar a página do arquivo, mas bloqueou a inspeção da tela por limite de chamadas do plano Starter. Nenhuma alteração desta atualização foi aplicada ao Figma. Quando o acesso estiver disponível, reutilizar componentes e tokens do arquivo, manter as camadas editáveis e conferir o resultado visual antes de considerar a sincronização concluída.

## Atualização pendente — Minha conta e ícones (01/10/2026)

O código implementa a tela `/minha-conta`, acessível pelo menu do nome do usuário. Ela permite editar nome e senha, com CPF somente leitura. A troca de senha exige senha atual; perfil e status não são alteráveis.

O menu usa estes ícones de `@mui/icons-material`:

| Item | Ícone |
|---|---|
| Abrir navegação | `Menu` |
| Exemplos | `ScienceOutlined` |
| Usuários | `PeopleAltOutlined` |
| Perfis | `AdminPanelSettingsOutlined` |
| Minha conta | `ManageAccountsOutlined` |
| Sair | `LogoutOutlined` |

A tentativa de consultar o arquivo pelo Figma MCP em 01/10/2026 foi bloqueada pelo limite de chamadas do plano Starter. O protótipo ainda não recebeu esta atualização.

Quando o acesso estiver disponível, atualizar os ícones e rótulos do menu, adicionar a tela Minha conta com os campos Nome, CPF somente leitura, Senha atual e Nova senha, e conectar o menu da conta a essa tela. Preservar o layout, as fontes e os componentes já usados no arquivo; conferir os links e o resultado visual antes de considerar a sincronização concluída.
