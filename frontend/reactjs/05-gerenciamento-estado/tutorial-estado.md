# Tutorial: Tema e estado compartilhado com Context

Neste tutorial você vai criar um tema (claro/escuro) e um estado de “usuário logado” usando a Context API e o hook `useContext`, para praticar gerenciamento de estado global.

## Passo 1: Configurar o projeto

Crie um projeto React com Vite (se ainda não tiver):

```bash
npm create vite@latest tutorial-estado -- --template react
cd tutorial-estado
npm install
```

## Passo 2: Criar o contexto de tema

Crie o arquivo `src/contexts/ThemeContext.jsx`:

```jsx
import { createContext, useState } from 'react';

export const ThemeContext = createContext();

export function ThemeProvider({ children }) {
  const [tema, setTema] = useState('claro');

  const alternarTema = () => {
    setTema(t => (t === 'claro' ? 'escuro' : 'claro'));
  };

  return (
    <ThemeContext.Provider value={{ tema, alternarTema }}>
      {children}
    </ThemeContext.Provider>
  );
}
```

## Passo 3: Criar o contexto de autenticação

Crie o arquivo `src/contexts/AuthContext.jsx`:

```jsx
import { createContext, useState } from 'react';

export const AuthContext = createContext();

export function AuthProvider({ children }) {
  const [usuario, setUsuario] = useState(null);

  const login = (nome) => setUsuario({ nome });
  const logout = () => setUsuario(null);

  return (
    <AuthContext.Provider value={{ usuario, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}
```

## Passo 4: Componente Painel com CSS Module e estilos dinâmicos

Crie o arquivo `src/components/Painel.module.css`:

```css
.painel {
  padding: 24px;
  min-height: 200px;
  border-radius: 8px;
}

.separator {
  margin: 16px 0;
  border: none;
  border-top: 1px solid rgba(0, 0, 0, 0.1);
}
```

Crie o arquivo `src/components/Painel.jsx`:

```jsx
import { useContext } from 'react';
import { ThemeContext } from '../contexts/ThemeContext';
import { AuthContext } from '../contexts/AuthContext';
import styles from './Painel.module.css';

function Painel() {
  const { tema, alternarTema } = useContext(ThemeContext);
  const { usuario, login, logout } = useContext(AuthContext);

  /* Cores que dependem do tema: use inline (valor dinâmico). Layout fixo fica no CSS Module. */
  const temaEstilos = {
    backgroundColor: tema === 'claro' ? '#f5f5f5' : '#333',
    color: tema === 'claro' ? '#333' : '#fff',
  };

  return (
    <div className={styles.painel} style={temaEstilos}>
      <h2>Painel</h2>
      <p>Tema atual: {tema}</p>
      <button onClick={alternarTema}>Alternar tema</button>

      <hr className={styles.separator} />

      {usuario ? (
        <>
          <p>Olá, {usuario.nome}!</p>
          <button onClick={logout}>Sair</button>
        </>
      ) : (
        <>
          <p>Você não está logado.</p>
          <button onClick={() => login('Aluno')}>Entrar</button>
        </>
      )}
    </div>
  );
}

export default Painel;
```

## Passo 5: Envolver a aplicação com os Providers

Crie `src/App.module.css` com uma classe para o container:

```css
.container {
  padding: 24px;
  max-width: 500px;
  margin: 0 auto;
}
```

Edite `src/App.jsx`:

```jsx
import styles from './App.module.css';
import { ThemeProvider } from './contexts/ThemeContext';
import { AuthProvider } from './contexts/AuthContext';
import Painel from './components/Painel';

function App() {
  return (
    <ThemeProvider>
      <AuthProvider>
        <div className={styles.container}>
          <h1>Estado global com Context</h1>
          <Painel />
        </div>
      </AuthProvider>
    </ThemeProvider>
  );
}

export default App;
```

## Passo 6: Executar a aplicação

```bash
npm run dev
```

Teste: alterne o tema (o fundo e a cor do texto devem mudar) e faça login/logout (a mensagem e os botões devem atualizar).

## Explicação dos principais elementos

- **createContext**: cria o “canal” de dados; o valor padrão é usado quando não há Provider acima.
- **Provider**: define o valor atual do contexto; todos os filhos podem consumi-lo com `useContext`.
- **useContext(ThemeContext)**: retorna o objeto `value` do Provider mais próximo (`tema` e `alternarTema`).
- **Dois Providers**: Theme e Auth são independentes; um componente pode usar os dois contextos sem conflito.
- **Estado no Provider**: o estado (`tema`, `usuario`) fica no Provider; ao atualizar, todos os consumidores daquele contexto re-renderizam.
- **Estilos**: layout fixo (padding, border-radius) no CSS Module; cores que dependem de `tema` em `style={}` (valor dinâmico), seguindo a boa prática de reservar inline para dados que vêm de estado ou props.

## Próximos passos

No módulo [06 - Rotas](../06-rotas/) você verá como usar o React Router para criar rotas no frontend e, depois, como proteger rotas com base no estado de autenticação.
