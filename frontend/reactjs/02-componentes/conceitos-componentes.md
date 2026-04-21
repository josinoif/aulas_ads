# Conceitos de Componentes

## Introdução

No React, a interface é construída a partir de **componentes**: blocos de código que encapsulam estrutura (JSX), estilo e comportamento. Um componente pode ser reutilizado em vários lugares e composto com outros componentes, formando uma árvore que representa a página.

Componentes podem ser escritos como **funções** (recomendado) ou como **classes**. Neste curso usamos componentes funcionais, que retornam JSX e podem usar hooks para estado e efeitos.

---

## O que é um componente?

Um componente é uma função (ou classe) que:

- Recebe dados opcionais via **props** (propriedades).
- Retorna elementos React (em geral JSX) que descrevem o que deve aparecer na tela.
- Pode ter estado interno (com `useState` ou outros hooks) e efeitos colaterais (com `useEffect`).

Exemplo:

```jsx
function Saudacao({ nome }) {
  return <p>Olá, {nome}!</p>;
}
```

Aqui `Saudacao` é um componente que recebe a prop `nome` e exibe uma mensagem.

---

## Props (propriedades)

**Props** são argumentos passados do componente pai para o filho. São somente leitura: o componente filho não deve alterá-las.

- Passar props: `<Saudacao nome="Maria" />`.
- Receber props: na função, use um parâmetro (objeto) com o nome da prop: `function Saudacao({ nome })`.
- Props podem ser strings, números, arrays, objetos ou até funções (callbacks).

Props permitem que o mesmo componente se comporte de forma diferente em cada uso, tornando-o reutilizável.

---

## Composição

**Composição** é o uso de um componente dentro de outro. Assim você monta a interface como blocos:

```jsx
function App() {
  return (
    <div>
      <Cabecalho />
      <Saudacao nome="João" />
      <Rodape />
    </div>
  );
}
```

- Componentes podem ter **children**: conteúdo colocado entre as tags de abertura e fechamento, acessível pela prop `children`.
- Exemplo: `<Card>Conteúdo aqui</Card>` — dentro de `Card` você usa `props.children`.

Composição evita componentes gigantes e facilita manutenção e testes.

---

## Vantagens de componentizar

1. **Reutilização**: escreva uma vez, use em vários lugares.
2. **Organização**: cada componente com uma responsabilidade clara.
3. **Manutenção**: alterações localizadas em um arquivo.
4. **Testes**: componentes pequenos são mais fáceis de testar.

---

## Estilização em React: boas práticas

No mercado, a estilização em React costuma seguir estas práticas:

- **CSS Modules**: cada componente pode ter um arquivo `.module.css` com o mesmo nome (ex.: `Cabecalho.module.css`). As classes são **escopadas** ao componente: não vazam para outros e não há conflito de nomes. No componente você importa `import styles from './Cabecalho.module.css'` e usa `className={styles.nomeDaClasse}`. O Vite suporta CSS Modules por padrão.
- **Um arquivo de estilo por componente**: mantém a manutenção próxima do JSX e facilita encontrar e alterar estilos.
- **Variáveis CSS (custom properties)**: para cores, espaçamentos e temas, use variáveis em `:root` (ex.: em `index.css`) e referencie com `var(--cor-primaria)`. Assim o tema ou o design system fica centralizado.
- **Inline styles apenas para valores dinâmicos**: use `style={{ }}` quando o valor vem de estado ou props (ex.: largura de uma barra de progresso, cor que muda com o tema). Para layout e aparência fixa, prefira CSS ou CSS Modules.
- **Evitar `!important`**: resolva especificidade com classes mais específicas ou com a estrutura do CSS Modules.

No tutorial a seguir você aplicará **CSS Modules** nos componentes.

---

## Conclusão

Componentes e props são a base do React. Você constrói a UI definindo componentes que recebem dados via props e se compõem uns nos outros. No próximo tutorial você criará vários componentes e praticará props e composição.
