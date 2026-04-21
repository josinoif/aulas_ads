# Tutorial: Rotas com React Router

Neste tutorial você vai configurar o React Router em um projeto React, criar rotas para Home, Sobre e um detalhe com parâmetro, e usar `Link` e `useNavigate`.

## Passo 1: Criar o projeto e instalar o React Router

```bash
npm create vite@latest tutorial-rotas -- --template react
cd tutorial-rotas
npm install
npm install react-router-dom
```

## Passo 2: Criar os componentes de página

Crie a pasta `src/pages` e os arquivos:

**src/pages/Home.jsx:**

```jsx
function Home() {
  return (
    <div>
      <h2>Home</h2>
      <p>Bem-vindo à página inicial.</p>
    </div>
  );
}

export default Home;
```

**src/pages/Sobre.jsx:**

```jsx
function Sobre() {
  return (
    <div>
      <h2>Sobre</h2>
      <p>Esta é a página sobre o projeto.</p>
    </div>
  );
}

export default Sobre;
```

**src/pages/Usuario.jsx:**

```jsx
import { useParams } from 'react-router-dom';

function Usuario() {
  const { id } = useParams();
  return (
    <div>
      <h2>Usuário</h2>
      <p>ID do usuário: {id}</p>
    </div>
  );
}

export default Usuario;
```

**src/pages/NaoEncontrada.jsx:**

```jsx
import { Link } from 'react-router-dom';

function NaoEncontrada() {
  return (
    <div>
      <h2>404 - Página não encontrada</h2>
      <Link to="/">Voltar ao início</Link>
    </div>
  );
}

export default NaoEncontrada;
```

## Passo 3: Criar o layout com navegação (CSS Module)

Crie `src/components/Layout.module.css`:

```css
.container {
  padding: 24px;
  max-width: 600px;
  margin: 0 auto;
}

.nav {
  margin-bottom: 20px;
}

.navLink {
  margin-right: 16px;
}
```

Crie `src/components/Layout.jsx`:

```jsx
import { Link, Outlet } from 'react-router-dom';
import styles from './Layout.module.css';

function Layout() {
  return (
    <div className={styles.container}>
      <nav className={styles.nav}>
        <Link to="/" className={styles.navLink}>Home</Link>
        <Link to="/sobre" className={styles.navLink}>Sobre</Link>
        <Link to="/usuario/1">Usuário 1</Link>
      </nav>
      <Outlet />
    </div>
  );
}

export default Layout;
```

- **Outlet**: é onde o React Router renderiza o componente filho da rota correspondente.
- **CSS Module**: estilos do layout em arquivo separado, com classes escopadas.

## Passo 4: Configurar o Router no App

Substitua `src/App.jsx` por:

```jsx
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Layout from './components/Layout';
import Home from './pages/Home';
import Sobre from './pages/Sobre';
import Usuario from './pages/Usuario';
import NaoEncontrada from './pages/NaoEncontrada';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Layout />}>
          <Route index element={<Home />} />
          <Route path="sobre" element={<Sobre />} />
          <Route path="usuario/:id" element={<Usuario />} />
          <Route path="*" element={<NaoEncontrada />} />
        </Route>
      </Routes>
    </BrowserRouter>
  );
}

export default App;
```

- **index**: rota filha que corresponde ao path do pai (aqui `/`).
- **usuario/:id**: `:id` é um parâmetro; em `Usuario` você lê com `useParams().id`.
- **path="*"**: captura qualquer URL não definida (404).

## Passo 5: Executar a aplicação

```bash
npm run dev
```

Navegue pelos links e acesse diretamente `/usuario/42` para ver o parâmetro na página.

## Explicação dos principais elementos

- **BrowserRouter**: usa a API History; a URL no navegador reflete a rota atual.
- **Routes / Route**: cada `Route` associa um `path` a um `element` (componente).
- **Link**: navega sem recarregar a página; o atributo `to` é o path.
- **Outlet**: dentro de um layout, renderiza o componente da rota filha ativa.
- **useParams**: retorna um objeto com os parâmetros da URL (ex.: `{ id: '1' }`).

## Próximos passos

No módulo [07 - Layouts](../07-layouts/) você verá como estruturar cabeçalho, menu e área de conteúdo de forma responsiva.
