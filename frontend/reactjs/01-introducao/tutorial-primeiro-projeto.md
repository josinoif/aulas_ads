# Tutorial: Primeiro projeto React

Neste tutorial você vai criar seu primeiro projeto React com **Vite** (ferramenta moderna e rápida recomendada pela documentação oficial), entender a estrutura de pastas e rodar a aplicação no navegador. O projeto usa **React 19**.

## Passo 1: Criar o projeto

No terminal, navegue até a pasta onde deseja criar o projeto e execute:

```bash
npm create vite@latest meu-primeiro-react -- --template react
cd meu-primeiro-react
npm install
```

- `npm create vite@latest` cria um novo projeto Vite.
- `--template react` usa o template oficial com React.
- `npm install` instala as dependências (incluindo React 19).

## Passo 2: Estrutura de pastas

Após a criação, você terá algo como:

```
meu-primeiro-react/
├── node_modules/    # Dependências (não editar)
├── public/          # Arquivos estáticos (favicon)
├── src/             # Código fonte da aplicação
│   ├── App.jsx      # Componente principal
│   ├── App.css      # Estilos do App
│   ├── main.jsx     # Ponto de entrada (monta o App no DOM)
│   └── index.css    # Estilos globais
├── index.html       # HTML raiz (na raiz do projeto)
├── package.json     # Scripts e dependências do projeto
└── vite.config.js   # Configuração do Vite
```

- **index.html** (na raiz): contém o `<div id="root">` onde o React será montado; o Vite injeta o script de `src/main.jsx`.
- **src/main.jsx**: importa o componente `App` e o renderiza com `createRoot` (API do React 18+).
- **src/App.jsx**: componente raiz da aplicação; é aqui que você começa a editar.

## Passo 3: Editar o App.jsx

Abra `src/App.jsx` e substitua o conteúdo por algo simples:

```jsx
function App() {
  return (
    <div className="App">
      <h1>Meu primeiro React</h1>
      <p>Se você vê esta mensagem, o projeto está funcionando!</p>
    </div>
  );
}

export default App;
```

- **function App()**: define um componente funcional chamado `App`.
- **return**: retorna JSX (o “HTML” que o React vai exibir).
- **export default App**: permite que outros arquivos importem este componente.

No React 19 não é obrigatório importar `React` no topo para usar JSX; o compilador do Vite cuida disso.

## Passo 4: Executar a aplicação

No terminal, dentro da pasta do projeto:

```bash
npm run dev
```

O servidor de desenvolvimento sobe e o navegador pode ser aberto em `http://localhost:5173` (a URL aparece no terminal). Você verá o título e o parágrafo que colocou no `App.jsx`.

## Explicação dos principais elementos

- **Vite**: ferramenta de build moderna que usa ES modules nativos no desenvolvimento; é rápida e a recomendação atual para novos projetos React (o Create React App está em manutenção).
- **npm run dev**: inicia o servidor de desenvolvimento do Vite, com recarga instantânea quando você salva os arquivos.
- **React**: a biblioteca que interpreta os componentes e o JSX.
- **root**: em `index.html` existe um `<div id="root">`; o `main.jsx` usa `createRoot` para “montar” o React nesse elemento.

## Próximos passos

No módulo [02 - Componentes](../02-componentes/) você aprenderá a criar e reutilizar componentes, usar props e aplicar **CSS Modules** para estilização seguindo boas práticas.
