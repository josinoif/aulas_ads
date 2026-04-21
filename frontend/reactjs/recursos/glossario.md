# Glossário — Termos do curso React

| Termo | Definição |
|-------|-----------|
| **Componente** | Bloco de código (função ou classe) que retorna elementos React (JSX) e pode receber props e ter estado. Unidade básica de construção da interface. |
| **Props** | Propriedades passadas de um componente pai para um filho. Somente leitura no filho. |
| **Estado (state)** | Dados que podem mudar ao longo do tempo e que, ao serem atualizados, causam nova renderização do componente. Gerenciado por `useState` ou `useReducer`. |
| **Hook** | Função especial do React que permite usar estado, efeitos e outros recursos em componentes funcionais. Ex.: `useState`, `useEffect`, `useContext`. |
| **JSX** | Sintaxe que mistura JavaScript com marcação semelhante a HTML. É transformada em chamadas a `React.createElement`. |
| **Virtual DOM** | Representação em memória da árvore do DOM. O React compara com a árvore anterior e atualiza apenas o necessário no DOM real. |
| **Ciclo de vida** | Fases pelas quais um componente passa: montagem (entra na tela), atualização (re-render) e desmontagem (sai da tela). Em componentes funcionais, efeitos são tratados com `useEffect`. |
| **Context (Contexto)** | Mecanismo do React para repassar dados pela árvore de componentes sem passar props em cada nível. Usa `createContext`, `Provider` e `useContext`. |
| **SPA** | Single Page Application — aplicação que carrega uma única página HTML e atualiza o conteúdo via JavaScript, sem recarregar a página. |
| **Rota** | Associação entre um caminho de URL e um componente a ser exibido. No React Router: `Route`, `path`, `element`. |
| **Effect (efeito)** | Lógica que deve rodar após a renderização ou em resposta a mudanças (ex.: fetch, subscriptions, timers). Implementada com `useEffect`. |
| **Ref** | Referência a um elemento DOM ou a um valor que persiste entre renderizações sem causar re-render. Criada com `useRef`. |
| **Renderização** | Processo em que o React chama a função do componente, obtém o JSX e atualiza o DOM conforme necessário. |
| **Re-renderização** | Nova execução da função do componente (por mudança de estado ou props), gerando uma nova árvore de elementos e possivelmente atualizações no DOM. |
| **CSS Module** | Arquivo `.module.css` cujas classes são escopadas ao componente que as importa; evita conflito de nomes e é uma prática comum para estilização em React. |
