# Integração com APIs

## Introdução

A maioria das aplicações React precisa trocar dados com um servidor: buscar listas, enviar formulários, atualizar ou excluir registros. Isso é feito por meio de **requisições HTTP** a **APIs** (em geral REST, expostas como URLs que respondem com JSON). No frontend, as ferramentas mais usadas são **fetch** (nativo do navegador) e a biblioteca **axios**.

---

## Conceitos

- **REST**: estilo de API em que recursos são identificados por URLs; verbos HTTP (GET, POST, PUT, PATCH, DELETE) indicam a ação. Respostas costumam ser em JSON.
- **fetch**: API nativa do navegador para HTTP. Retorna uma Promise; é preciso chamar `.json()` no corpo da resposta para obter o objeto JavaScript.
- **axios**: biblioteca que simplifica requisições (interceptors, transformação automática de JSON, tratamento de erros). Muito usada em projetos React.
- **Estados da requisição**: ao chamar uma API, a aplicação passa por estados: **loading** (carregando), **success** (dados recebidos), **error** (falha). É importante tratar os três na UI (loading, lista/detalhe, mensagem de erro).

---

## Boas práticas

- **useEffect para GET**: busque dados ao montar o componente (ou quando um parâmetro mudar) com `useEffect`; armazene o resultado em estado (`useState`) e exiba loading/erro conforme o estado.
- **Tratamento de erros**: use `try/catch` em chamadas assíncronas e defina um estado de erro (ex.: `setError(err.message)`); exiba uma mensagem amigável ao usuário.
- **Cancelar requisições**: em componentes que podem desmontar antes da resposta, use AbortController (com fetch) ou cancel tokens (com axios) para evitar atualizar estado em componente desmontado.
- **URLs e credenciais**: não coloque chaves de API no código do frontend; use variáveis de ambiente (ex.: `process.env.REACT_APP_API_URL`) e deixe operações sensíveis no backend.

---

## Conclusão

Integrar com APIs envolve fazer requisições HTTP, gerenciar loading/erro/sucesso e exibir os dados na interface. Os tutoriais [tutorial-formulario-crud.md](tutorial-formulario-crud.md) e [tutorial-listagem-api.md](tutorial-listagem-api.md) mostram um formulário que envia dados (POST) e uma listagem que busca dados (GET) com axios.
