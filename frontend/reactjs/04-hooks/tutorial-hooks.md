# Tutorial: Aplicando vários hooks em um componente

Neste tutorial você vai construir um pequeno painel que usa **useState**, **useEffect**, **useMemo** e **useCallback** juntos: um contador, um título dinâmico, uma lista filtrada e um botão que chama uma função memorizada.

## Passo 1: Configurar o projeto

Crie um projeto React com Vite (se ainda não tiver um):

```bash
npm create vite@latest tutorial-hooks -- --template react
cd tutorial-hooks
npm install
```

## Passo 2: Estilos com CSS Module

Crie o arquivo `src/App.module.css`:

```css
.container {
  padding: 24px;
  max-width: 400px;
  margin: 0 auto;
}

.section {
  margin-bottom: 20px;
}
```

## Passo 3: Criar o componente com vários hooks

Substitua o conteúdo de `src/App.jsx` pelo seguinte:

```jsx
import { useState, useEffect, useMemo, useCallback } from 'react';
import styles from './App.module.css';

const LISTA = ['React', 'JavaScript', 'TypeScript', 'HTML', 'CSS', 'Node'];

function App() {
  const [count, setCount] = useState(0);
  const [filtro, setFiltro] = useState('');

  // useEffect: atualiza o título da página quando count muda
  useEffect(() => {
    document.title = `Contador: ${count}`;
  }, [count]);

  // useMemo: lista filtrada só é recalculada quando filtro ou LISTA mudam
  const listaFiltrada = useMemo(() => {
    return LISTA.filter(item =>
      item.toLowerCase().includes(filtro.toLowerCase())
    );
  }, [filtro]);

  // useCallback: função estável para não recriar a cada render
  const incrementar = useCallback(() => {
    setCount(c => c + 1);
  }, []);

  return (
    <div className={styles.container}>
      <h1>Painel com Hooks</h1>

      <section className={styles.section}>
        <p>Contador: <strong>{count}</strong></p>
        <button onClick={incrementar}>Incrementar</button>
      </section>

      <section className={styles.section}>
        <label>
          Filtrar lista: <input
            type="text"
            value={filtro}
            onChange={e => setFiltro(e.target.value)}
          />
        </label>
        <ul>
          {listaFiltrada.map(item => (
            <li key={item}>{item}</li>
          ))}
        </ul>
      </section>
    </div>
  );
}

export default App;
```

## Passo 4: Executar a aplicação

```bash
npm run dev
```

Teste: altere o contador (o título da aba deve mudar), digite no campo de filtro (a lista deve ser filtrada) e abra o React DevTools para observar as re-renderizações.

## Explicação dos principais elementos

- **useState**: `count` e `filtro` são estados locais; ao mudar, o componente re-renderiza e a UI atualiza.
- **useEffect**: o efeito roda quando `count` muda; atualiza `document.title` para refletir o contador.
- **useMemo**: `listaFiltrada` é o resultado do filtro sobre `LISTA`. Só é recalculada quando `filtro` (ou `LISTA`) muda, evitando trabalho desnecessário a cada render.
- **useCallback**: `incrementar` é uma função estável (dependências vazias). Em um componente filho com `React.memo`, passar `incrementar` evita re-render quando só outros estados mudam.
- **Array de dependências**: em `useEffect` e `useMemo`/`useCallback`, o array define quando o efeito ou o valor/função devem ser recalculados.

## Próximos passos

No módulo [05 - Gerenciamento de estado](../05-gerenciamento-estado/) você verá quando usar estado local vs global e como usar a Context API com `useContext` para compartilhar estado na árvore de componentes.
