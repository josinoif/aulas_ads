# Rotas no frontend (SPA e React Router)

## Introdução

Em uma **Single Page Application (SPA)**, a aplicação é carregada uma vez e a navegação entre “telas” acontece no próprio frontend, sem recarregar a página. As **rotas** definem qual componente deve ser exibido para cada URL (ex.: `/`, `/sobre`, `/usuarios/123`). No ecossistema React, a biblioteca mais usada para isso é o **React Router**.

---

## Conceitos principais

- **Rota**: associação entre um caminho (path) e um componente. Ex.: path `/contato` → componente `Contato`.
- **Router**: componente que envolve a aplicação e lê a URL para decidir o que renderizar (ex.: `BrowserRouter` usa a API History do navegador).
- **Routes / Route**: definem as rotas; dentro de `Routes`, cada `Route` tem um `path` e um `element` (o componente).
- **Link / NavLink**: componentes para navegação; geram `<a>` mas evitam recarregar a página, atualizando apenas o que o React Router controla.
- **useNavigate**: hook para navegar programaticamente (ex.: após login, redirecionar para `/dashboard`).
- **useParams**: hook para ler parâmetros dinâmicos da URL (ex.: `/usuarios/:id` → `id`).

---

## Rotas protegidas

Para páginas que exigem autenticação, você pode criar um componente (ex.: `RotaProtegida`) que usa o contexto de autenticação: se o usuário não estiver logado, renderiza um redirecionamento para `/login`; caso contrário, renderiza o componente filho (ex.: `Outlet` ou `children`). Assim, rotas como `/dashboard` só são acessíveis para usuários autenticados.

---

## Boas práticas

- Centralize a definição de rotas em um único lugar (ex.: componente `Rotas` ou arquivo `routes.jsx`).
- Use rotas aninhadas (`Route` dentro de `Route`) e `Outlet` para layouts compartilhados (cabeçalho, menu) com conteúdo que muda.
- Para 404, use um `Route` com `path="*"` e um componente de “página não encontrada”.

---

## Conclusão

O React Router permite construir SPAs com URLs legíveis e navegação fluida. Dominar `Route`, `Link`, `useNavigate` e `useParams` é suficiente para a maioria das aplicações; rotas protegidas são implementadas verificando o estado de autenticação antes de renderizar o conteúdo. No [tutorial-rotas.md](tutorial-rotas.md) você configurará rotas, links e parâmetros na prática.
