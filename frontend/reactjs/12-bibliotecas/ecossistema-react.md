# Ecossistema React e bibliotecas úteis

## Introdução

O React é uma biblioteca focada em interface; para roteamento, formulários, UI pronta e gerenciamento de estado avançado, a comunidade e a própria Meta oferecem ou recomendam **bibliotecas** que se integram bem ao React. Conhecer o ecossistema ajuda a escolher ferramentas adequadas ao projeto e a acelerar o desenvolvimento.

---

## Roteamento

- **React Router** (react-router-dom): padrão de fato para SPA. Fornece `BrowserRouter`, `Routes`, `Route`, `Link`, `useNavigate`, `useParams`, etc. Essencial para aplicações com múltiplas páginas.

---

## UI e componentes prontos

- **Material-UI (MUI)**: conjunto de componentes que seguem o Material Design. Inclui botões, inputs, tabelas, modais, temas. Muito usado em dashboards e aplicações empresariais.
- **Chakra UI**: componentes acessíveis e customizáveis, com boa documentação e tema configurável. Bom para protótipos e projetos que priorizam acessibilidade.
- **Ant Design**: biblioteca rica em componentes (tabelas, formulários, gráficos). Comum em aplicações internas e admin.
- **React Bootstrap**: componentes Bootstrap adaptados para React (botões, grid, cards, modais).

Escolha conforme o visual desejado e a curva de aprendizado; todas reduzem o tempo para montar layouts e formulários consistentes.

---

## Formulários

- **React Hook Form**: foca em performance e poucas re-renderizações. Trabalha com validação (própria ou com Yup/Zod). Muito usado em formulários grandes ou com muitos campos.
- **Formik**: alternativa clássica para formulários controlados, validação e mensagens de erro. API simples e amplamente conhecida.

---

## Estado global avançado

- **Redux / Redux Toolkit**: para estado global complexo, com histórico de ações e DevTools. Redux Toolkit simplifica a configuração.
- **Zustand**: store leve e simples; boa opção quando Context não basta mas você não quer a estrutura do Redux.
- **Jotai**: estado atômico; cada pedaço de estado é um “atom” que pode ser lido e atualizado de qualquer componente.

Use Context para temas e auth; considere Zustand ou Redux quando houver muito estado compartilhado ou lógica complexa de atualização.

---

## Requisições HTTP e dados

- **Axios**: cliente HTTP com interceptors, cancelamento e suporte a FormData. Muito usado junto com React.
- **TanStack Query (React Query)**: cache de requisições, refetch, estados de loading/erro/sucesso e invalidação. Ideal para dados que vêm de API e são exibidos em várias telas.

---

## Testes

- **React Testing Library**: testa componentes do ponto de vista do usuário (render, interação, queries por papel ou texto). Recomendado pela documentação do React.
- **Jest**: runner de testes e assertions; geralmente usado junto com React Testing Library.

---

## Outras ferramentas

- **Vite**: ferramenta recomendada para criar e rodar projetos React; build e recarga muito rápidos. Use `npm create vite@latest meu-app -- --template react`.
- **ESLint + eslint-plugin-react**: lint e boas práticas para código React.
- **React DevTools**: extensão do navegador para inspecionar árvore de componentes, props e estado.

---

## Conclusão

O ecossistema React oferece soluções consolidadas para rotas, UI, formulários, estado e requisições. Comece com o que o curso já cobre (React Router, Context, axios) e adicione bibliotecas conforme a necessidade: UI kit para acelerar o layout, React Hook Form para formulários complexos, React Query para cache de API. Consulte a pasta [recursos](../recursos/) para glossário e referências.
