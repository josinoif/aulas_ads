# Tutorial: Upload e listagem/download de arquivos

Neste tutorial você vai criar um formulário de **upload** de arquivo (envio com FormData para uma API) e uma área que simula **listagem e download**. A API pode ser simulada com um serviço como [CRUDCrud](https://crudcrud.com) ou um backend local; aqui usamos uma URL de exemplo.

## Passo 1: Configurar o projeto

```bash
npm create vite@latest tutorial-arquivos -- --template react
cd tutorial-arquivos
npm install
npm install axios
```

## Passo 2: Componente de Upload (com CSS Module)

Crie a pasta `src/components` e o arquivo `src/components/UploadArquivo.module.css`:

```css
.section {
  margin-bottom: 24px;
}

.success {
  color: green;
}

.error {
  color: red;
}
```

Crie o arquivo `src/components/UploadArquivo.jsx`:

```jsx
import { useState } from 'react';
import axios from 'axios';
import styles from './UploadArquivo.module.css';

function UploadArquivo() {
  const [arquivo, setArquivo] = useState(null);
  const [status, setStatus] = useState(''); // 'enviando' | 'sucesso' | 'erro'
  const [nomeArquivo, setNomeArquivo] = useState('');

  const handleFileChange = (e) => {
    const file = e.target.files?.[0];
    if (file) {
      setArquivo(file);
      setNomeArquivo(file.name);
      setStatus('');
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!arquivo) return;
    setStatus('enviando');
    try {
      const formData = new FormData();
      formData.append('arquivo', arquivo);
      await axios.post('https://httpbin.org/post', formData, {
        headers: { 'Content-Type': 'multipart/form-data' },
      });
      setStatus('sucesso');
      setArquivo(null);
      setNomeArquivo('');
      e.target.reset();
    } catch (err) {
      setStatus('erro');
    }
  };

  return (
    <div className={styles.section}>
      <h3>Upload de arquivo</h3>
      <form onSubmit={handleSubmit}>
        <input type="file" onChange={handleFileChange} />
        {nomeArquivo && <p>Arquivo selecionado: {nomeArquivo}</p>}
        <button type="submit" disabled={!arquivo || status === 'enviando'}>
          {status === 'enviando' ? 'Enviando...' : 'Enviar'}
        </button>
      </form>
      {status === 'sucesso' && <p className={styles.success}>Enviado com sucesso!</p>}
      {status === 'erro' && <p className={styles.error}>Erro ao enviar.</p>}
    </div>
  );
}

export default UploadArquivo;
```

## Passo 3: Componente de listagem e download (simulado, com CSS Module)

Crie `src/components/ListaArquivos.module.css`:

```css
.list {
  list-style: none;
  padding: 0;
}

.item {
  margin-bottom: 8px;
}

.hint {
  font-size: 12px;
  color: #666;
}
```

Crie `src/components/ListaArquivos.jsx`:

```jsx
import styles from './ListaArquivos.module.css';

const arquivosSimulados = [
  { id: 1, nome: 'documento.pdf', url: '#' },
  { id: 2, nome: 'imagem.png', url: '#' },
];

function ListaArquivos() {
  const handleDownload = (nome, url) => {
    if (url === '#') {
      alert('Em produção, aqui seria o link real de download da API.');
      return;
    }
    const link = document.createElement('a');
    link.href = url;
    link.download = nome;
    link.click();
  };

  return (
    <div>
      <h3>Arquivos disponíveis</h3>
      <ul className={styles.list}>
        {arquivosSimulados.map((arq) => (
          <li key={arq.id} className={styles.item}>
            {arq.nome}{' '}
            <button onClick={() => handleDownload(arq.nome, arq.url)}>
              Baixar
            </button>
          </li>
        ))}
      </ul>
      <p className={styles.hint}>
        Para download real, a API deve retornar a URL do arquivo ou o blob; o frontend usa essa URL em um &lt;a download&gt; ou cria um Object URL a partir do blob.
      </p>
    </div>
  );
}

export default ListaArquivos;
```

## Passo 4: Integrar no App (com CSS Module)

Crie `src/App.module.css`:

```css
.container {
  padding: 24px;
  max-width: 500px;
  margin: 0 auto;
}

.title {
  margin-bottom: 24px;
}
```

Edite `src/App.jsx`:

```jsx
import styles from './App.module.css';
import UploadArquivo from './components/UploadArquivo';
import ListaArquivos from './components/ListaArquivos';

function App() {
  return (
    <div className={styles.container}>
      <h1 className={styles.title}>Upload e download de arquivos</h1>
      <UploadArquivo />
      <ListaArquivos />
    </div>
  );
}

export default App;
```

## Passo 5: Executar a aplicação

```bash
npm run dev
```

Selecione um arquivo, clique em Enviar e observe o estado "Enviando..." e a resposta (httpbin.org devolve o que recebeu). A listagem mostra como disparar um download; em produção você usaria a URL retornada pela API.

## Explicação dos principais elementos

- **FormData**: monta o corpo da requisição como multipart/form-data; `append('arquivo', file)` envia o arquivo com o nome do campo esperado pelo backend.
- **input type="file"**: `e.target.files[0]` é o objeto **File**; tem `name`, `size`, `type`.
- **Download**: em uma API real, o backend pode retornar uma URL de download ou o blob; com blob você usa `URL.createObjectURL(blob)` e um `<a download>` para forçar o download.

## Próximos passos

No módulo [11 - Multimídia](../11-multimidia/) você verá como exibir e controlar áudio, vídeo e imagens em React.
