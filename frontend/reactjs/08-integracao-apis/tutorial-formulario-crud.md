# Criação de Formulário em ReactJS

Para criar uma tela de formulário em React que envia dados para uma aplicação CRUD, como a CRUDCrud (um serviço simples de armazenamento de dados via API REST), siga os passos abaixo:

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

##  Passo 2: Criar o Formulário

1. Crie o arquivo `src/CrudForm.module.css` (estilos do formulário com CSS Module):

```css
.formGroup {
  margin-bottom: 16px;
}

.label {
  display: block;
  margin-bottom: 4px;
}

.input {
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
}

.button {
  padding: 8px 16px;
  cursor: pointer;
}
```

2. Crie o componente `src/CrudForm.jsx`:

```jsx
import { useState } from 'react';
import axios from 'axios';
import styles from './CrudForm.module.css';

function CrudForm() {
  const [formData, setFormData] = useState({
    name: '',
    email: '',
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData({
      ...formData,
      [name]: value,
    });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();

    const url = 'https://crudcrud.com/api/YOUR_UNIQUE_ENDPOINT/users';

    try {
      const response = await axios.post(url, formData);

      if (response.status === 201) {
        alert('Usuário criado com sucesso!');
        setFormData({ name: '', email: '' });
      } else {
        alert('Erro ao criar usuário.');
      }
    } catch (error) {
      console.error('Erro:', error);
      alert('Erro ao se conectar à API.');
    }
  };

  return (
    <form onSubmit={handleSubmit}>
      <div className={styles.formGroup}>
        <label htmlFor="name" className={styles.label}>Nome:</label>
        <input
          type="text"
          id="name"
          name="name"
          value={formData.name}
          onChange={handleChange}
          className={styles.input}
          required
        />
      </div>
      <div className={styles.formGroup}>
        <label htmlFor="email" className={styles.label}>Email:</label>
        <input
          type="email"
          id="email"
          name="email"
          value={formData.email}
          onChange={handleChange}
          className={styles.input}
          required
        />
      </div>
      <button type="submit" className={styles.button}>Cadastrar</button>
    </form>
  );
}

export default CrudForm;
```

## Passo 3: Explicação dos Principais Elementos

- axios.post: Utiliza o `axios` para fazer uma requisição POST para a URL fornecida com o `formData` como corpo da requisição.
- response.status: Verifica o status da resposta para confirmar se o usuário foi criado com sucesso. O status `201` é o código padrão para uma criação bem-sucedida.

## Passo 4:  Substitua o YOUR_UNIQUE_ENDPOINT
Substitua `"YOUR_UNIQUE_ENDPOINT"` pelo seu endpoint único fornecido pela CRUDCrud.

## Passo 5: Adicionar o Componente Form ao App (com CSS Module)

Crie `src/App.module.css`:

```css
.container {
  max-width: 500px;
  margin: 0 auto;
  padding: 24px;
}

.title {
  margin-bottom: 24px;
}
```

No arquivo `src/App.jsx`, importe os estilos e o componente:

```jsx
import styles from './App.module.css';
import CrudForm from './CrudForm';

function App() {
  return (
    <div className={styles.container}>
      <h1 className={styles.title}>Cadastro de Usuários</h1>
      <CrudForm />
    </div>
  );
}

export default App;
```

## Passo 6: Execute a Aplicação

```bash
npm run dev
```

Agora, o formulário em React utiliza axios para enviar os dados para a API CRUDCrud. A funcionalidade e o fluxo permanecem os mesmos, mas com `axios` para gerenciar as requisições HTTP.
