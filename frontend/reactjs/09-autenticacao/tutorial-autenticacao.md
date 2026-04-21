# Tutorial: Login, Context de autenticação e rota protegida

Neste tutorial você vai implementar um fluxo simples de autenticação: tela de login (simulada), Context que guarda usuário e token, e uma rota protegida que redireciona para login se o usuário não estiver autenticado.

## Passo 1: Criar o projeto e instalar dependências

```bash
npm create vite@latest tutorial-auth -- --template react
cd tutorial-auth
npm install
npm install react-router-dom
```

## Passo 2: Criar o AuthContext

Crie a pasta `src/contexts` e o arquivo `src/contexts/AuthContext.jsx`:

```jsx
import { createContext, useState, useContext, useEffect } from 'react';

const AuthContext = createContext(null);

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [token, setToken] = useState(() => localStorage.getItem('token'));

  useEffect(() => {
    const t = localStorage.getItem('token');
    if (t) {
      setToken(t);
      setUser({ nome: 'Usuário' }); // Em produção, decodifique o JWT ou busque o usuário na API
    }
  }, []);

  const login = (email, senha) => {
    // Simulação: em produção, faça POST para a API e use o token retornado
    const fakeToken = 'token-' + Date.now();
    localStorage.setItem('token', fakeToken);
    setToken(fakeToken);
    setUser({ nome: email });
  };

  const logout = () => {
    localStorage.removeItem('token');
    setToken(null);
    setUser(null);
  };

  const value = { user, token, login, logout, isAuthenticated: !!token };
  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth deve ser usado dentro de AuthProvider');
  return ctx;
}
```

## Passo 3: Tela de Login (com CSS Module)

Crie a pasta `src/pages` e o arquivo `src/pages/Login.module.css`:

```css
.wrapper {
  max-width: 400px;
  margin: 40px auto;
  padding: 24px;
}

.formGroup {
  margin-bottom: 16px;
}

.label {
  display: block;
  margin-bottom: 4px;
}

.input {
  display: block;
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
}
```

Crie o arquivo `src/pages/Login.jsx`:

```jsx
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';
import styles from './Login.module.css';

function Login() {
  const [email, setEmail] = useState('');
  const [senha, setSenha] = useState('');
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();
    login(email, senha);
    navigate('/dashboard');
  };

  return (
    <div className={styles.wrapper}>
      <h2>Login</h2>
      <form onSubmit={handleSubmit}>
        <div className={styles.formGroup}>
          <label className={styles.label}>Email</label>
          <input
            type="email"
            value={email}
            onChange={e => setEmail(e.target.value)}
            className={styles.input}
            required
          />
        </div>
        <div className={styles.formGroup}>
          <label className={styles.label}>Senha</label>
          <input
            type="password"
            value={senha}
            onChange={e => setSenha(e.target.value)}
            className={styles.input}
            required
          />
        </div>
        <button type="submit">Entrar</button>
      </form>
    </div>
  );
}

export default Login;
```

## Passo 4: Rota protegida

Crie `src/components/RotaProtegida.jsx`:

```jsx
import { Navigate } from 'react-router-dom';
import { useAuth } from '../contexts/AuthContext';

function RotaProtegida({ children }) {
  const { isAuthenticated } = useAuth();
  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }
  return children;
}

export default RotaProtegida;
```

## Passo 5: Páginas Home, Dashboard e Layout

**src/pages/Home.jsx:**

```jsx
import { Link } from 'react-router-dom';

function Home() {
  return (
    <div>
      <h2>Home</h2>
      <p><Link to="/login">Fazer login</Link></p>
    </div>
  );
}

export default Home;
```

**src/pages/Dashboard.jsx:**

```jsx
import { useAuth } from '../contexts/AuthContext';

function Dashboard() {
  const { user, logout } = useAuth();
  return (
    <div>
      <h2>Dashboard</h2>
      <p>Olá, {user?.nome}!</p>
      <button onClick={logout}>Sair</button>
    </div>
  );
}

export default Dashboard;
```

## Passo 6: Configurar App com Router e AuthProvider

Substitua `src/App.jsx`:

```jsx
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './contexts/AuthContext';
import RotaProtegida from './components/RotaProtegida';
import Home from './pages/Home';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/login" element={<Login />} />
          <Route path="/dashboard" element={
            <RotaProtegida>
              <Dashboard />
            </RotaProtegida>
          } />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </BrowserRouter>
    </AuthProvider>
  );
}

export default App;
```

## Passo 7: Executar a aplicação

```bash
npm run dev
```

Teste: acesse `/dashboard` sem estar logado — deve redirecionar para `/login`. Faça login e será redirecionado para `/dashboard`. Clique em "Sair" e o estado é limpo.

## Explicação dos principais elementos

- **AuthContext**: guarda `user`, `token`, `login` e `logout`; o token é persistido em `localStorage` e restaurado ao recarregar a página.
- **RotaProtegida**: usa `useAuth()`; se `isAuthenticated` for false, renderiza `<Navigate to="/login" />`; caso contrário, renderiza os filhos (a página protegida).
- **useNavigate**: após login bem-sucedido, redireciona programaticamente para `/dashboard`.

## Próximos passos

No módulo [10 - Arquivos](../10-arquivos/) você verá como enviar e receber arquivos (upload e download) no frontend.
