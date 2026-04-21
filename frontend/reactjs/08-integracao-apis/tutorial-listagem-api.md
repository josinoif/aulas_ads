# Criação de Listagem em ReactJS

Para criar uma tela de listagem em React, que lê dados de uma API e exibe todos os itens devolvidos em uma tela siga as instruções abaixo:


##  Passo 1: Configurar o Projeto

1. Crie um novo projeto React com Vite (React 19):

```bash
npm create vite@latest my-form -- --template react
cd my-form
npm install
```

2. Instale o Axios para fazer requisições HTTP:

```bash 
npm install axios
```

##  Passo 2: Estilos da tabela com CSS Module

Crie o arquivo `src/ItemList.module.css`:

```css
.table {
  width: 100%;
  border-collapse: collapse;
  margin: 20px 0;
}

.table,
.th,
.td {
  border: 1px solid #ddd;
}

.th,
.td {
  padding: 8px;
  text-align: left;
}

.th {
  background-color: #f2f2f2;
}
```

##  Passo 3: Criar o componente List

Crie o componente `src/ItemList.jsx` que busca os dados da API e exibe em uma tabela:

```jsx
import { useEffect, useState } from 'react';
import axios from 'axios';
import styles from './ItemList.module.css';

function ItemList() {
  const [items, setItems] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const url = 'https://crudcrud.com/api/YOUR_UNIQUE_ENDPOINT/users';

    const fetchData = async () => {
      try {
        const response = await axios.get(url);
        setItems(response.data);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  if (loading) return <p>Carregando...</p>;
  if (error) return <p>Erro ao carregar dados: {error}</p>;

  return (
    <div>
      <h2>Lista de Usuários</h2>
      <table className={styles.table}>
        <thead>
          <tr>
            <th className={styles.th}>ID</th>
            <th className={styles.th}>Nome</th>
            <th className={styles.th}>Email</th>
          </tr>
        </thead>
        <tbody>
          {items.map((item) => (
            <tr key={item._id}>
              <td className={styles.td}>{item._id}</td>
              <td className={styles.td}>{item.name}</td>
              <td className={styles.td}>{item.email}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default ItemList;
```

## Passo 4: Explicação dos Principais Elementos

- **useEffect**: Utilizado para fazer a chamada à API quando o componente é montado. Faz a requisição GET para buscar todos os itens.
- **axios.get**: Faz a requisição para a URL da API.
- **loading, error**: Estados para gerenciar o carregamento e possíveis erros.
- **items.map**: Itera sobre os itens recebidos e os exibe em linhas da tabela.
- **CSS Module**: os estilos da tabela ficam em `ItemList.module.css`, escopados ao componente, evitando afetar outras tabelas da aplicação.

## Passo 5: Substitua o YOUR_UNIQUE_ENDPOINT

Substitua `"YOUR_UNIQUE_ENDPOINT"` pelo seu endpoint único fornecido pela CRUDCrud.

## Passo 6: Adicionar o Componente List ao App (com CSS Module)

Se ainda não tiver, crie `src/App.module.css`:

```css
.container {
  max-width: 600px;
  margin: 0 auto;
  padding: 24px;
}

.title {
  margin-bottom: 24px;
}
```

No arquivo `src/App.jsx`, importe os estilos e os componentes:

```jsx
import styles from './App.module.css';
import CrudForm from './CrudForm';
import ItemList from './ItemList';

function App() {
  return (
    <div className={styles.container}>
      <h1 className={styles.title}>Cadastro de Usuários</h1>
      <CrudForm />
      <ItemList />
    </div>
  );
}

export default App;
```

## Passo 7: Execute a Aplicação

```bash
npm run dev
```

Agora você terá uma tela de listagem que exibe todos os itens cadastrados em uma tabela HTML. O componente ItemList faz uma requisição à API, exibe os itens em uma tabela e lida com estados de carregamento e erro.
