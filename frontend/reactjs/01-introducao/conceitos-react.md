# Conceitos de React

## Introdução

React é uma biblioteca JavaScript criada pelo Facebook (atualmente Meta) para construção de interfaces de usuário. Foi lançada em 2013 e tornou-se uma das ferramentas mais usadas no desenvolvimento frontend. Diferente de um framework completo, o React foca apenas na camada de visualização: você define como a interface deve parecer em cada estado da aplicação, e o React cuida da atualização eficiente do DOM.

Com React, você trabalha com **componentes** reutilizáveis e declarativos. Em vez de manipular o DOM diretamente, você descreve a UI em função dos dados (estado e props), e o React atualiza a tela quando esses dados mudam.

---

## Por que React?

- **Componentização**: A interface é dividida em blocos independentes e reutilizáveis.
- **Declarativo**: Você descreve *o que* deve ser exibido, não *como* alterar o DOM passo a passo.
- **Ecossistema**: Grande comunidade, bibliotecas e ferramentas (roteamento, estado, testes).
- **Virtual DOM**: Atualizações eficientes, minimizando alterações no DOM real.
- **Aprendizado progressivo**: Comece com HTML/CSS/JS e vá incorporando rotas, estado global, etc.

---

## Virtual DOM

O React mantém uma representação em memória da árvore do DOM, chamada **Virtual DOM**. Quando o estado ou as props mudam:

1. React gera uma nova árvore virtual.
2. Compara com a árvore anterior (processo chamado *reconciliation*).
3. Calcula o conjunto mínimo de alterações no DOM real.
4. Aplica apenas essas alterações.

Isso reduz operações custosas no DOM e mantém a interface fluida mesmo com muitas atualizações.

---

## JSX

JSX é uma extensão de sintaxe que permite escrever estruturas parecidas com HTML dentro de JavaScript. O React usa JSX para descrever a interface.

```jsx
const elemento = <h1>Olá, mundo!</h1>;
```

- **Não é HTML**: É transformado em chamadas a `React.createElement`. Por isso usamos `className` em vez de `class`, e `htmlFor` em vez de `for`.
- **JavaScript dentro do JSX**: Use `{ }` para expressões (variáveis, funções, condicionais).
- **Um elemento raiz**: O retorno de um componente deve ter um único elemento pai (ou Fragment `<>...</>`).

---

## Ecossistema

- **Vite**: ferramenta recomendada para criar e rodar projetos React (rápida, com recarga instantânea). O Create React App está em manutenção e não é mais recomendado para novos projetos.
- **React Router**: roteamento no frontend (SPA).
- **Context API**: compartilhamento de estado sem bibliotecas externas.
- **Bibliotecas de UI**: Material-UI, Chakra UI, Ant Design.
- **Gerenciamento de estado**: Redux, Zustand, Jotai (para aplicações maiores).

---

## Conclusão

React é uma biblioteca focada em componentes e em atualizações eficientes da interface. Entender Virtual DOM e JSX é a base para construir frontends modernos. Nos próximos módulos você verá componentes, hooks e integração com APIs e autenticação.
