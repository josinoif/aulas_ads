# Context API e padrões de estado

## Introdução

A **Context API** do React permite fornecer dados (e funções) para toda uma subárvore de componentes sem precisar passar props manualmente em cada nível. Junto com o hook **useContext**, ela é a ferramenta nativa mais usada para estado “global” em aplicações React de tamanho pequeno a médio.

---

## Como funciona

1. **createContext**: você cria um contexto (ex.: `ThemeContext`, `AuthContext`) com um valor padrão.
2. **Provider**: um componente “provedor” envolve a parte da árvore que pode consumir esse contexto e define o valor atual (normalmente estado + setters ou funções).
3. **useContext**: em qualquer componente filho do Provider, você chama `useContext(MeuContext)` e recebe o valor atual.

Qualquer atualização no valor do Provider faz com que todos os componentes que usam aquele contexto re-renderizem. Por isso é importante não colocar no mesmo contexto dados que mudam com frequências muito diferentes (ex.: tema vs lista de itens em tempo real).

---

## Padrões de uso

### 1. Contexto com useState no Provider

O Provider mantém o estado com `useState` (ou `useReducer`) e passa valor e funções de atualização no `value`. Os consumidores usam `useContext` para ler e atualizar.

### 2. Múltiplos contextos

Em vez de um único contexto gigante, use vários contextos menores (ex.: `ThemeContext`, `AuthContext`, `CartContext`). Assim, uma mudança de tema não re-renderiza quem só consome o carrinho.

### 3. Custom hook para o contexto

Em vez de expor o contexto diretamente, crie um hook `useAuth()` que chama `useContext(AuthContext)` e retorna o valor. Se o contexto for usado fora do Provider, o hook pode lançar um erro explicativo. Isso centraliza o uso e facilita refatorações.

### 4. Separar estado e dispatch

Para estado complexo, você pode ter um contexto só para o estado (leitura) e outro para as ações (dispatch), ou um único contexto com um objeto `{ state, dispatch }`. Assim, componentes que só disparam ações não precisam re-renderizar quando só o estado muda (se você usar padrões como separar Provider de estado e dispatch).

---

## Vantagens e limitações

- **Vantagens**: já vem com o React, não precisa de bibliotecas, sintaxe simples com hooks, bom para tema, autenticação e preferências.
- **Limitações**: todos os consumidores re-renderizam quando o valor do contexto muda; para estado muito grande ou que muda muito, Redux, Zustand ou Jotai costumam oferecer mais controle de performance e ferramentas (DevTools, middlewares).

---

## Conclusão

A Context API com `useContext` é a base para gerenciamento de estado compartilhado em React sem dependências externas. Usar múltiplos contextos e custom hooks mantém o código organizado. No [tutorial-estado.md](tutorial-estado.md) você implementará um tema e um estado de “usuário logado” com Context.
