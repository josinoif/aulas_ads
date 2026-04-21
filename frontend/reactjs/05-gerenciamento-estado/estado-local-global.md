# Estado local vs estado global

## Introdução

Em toda aplicação React, dados que mudam ao longo do tempo são representados por **estado**. Decidir onde esse estado deve viver — em um único componente (local) ou compartilhado por vários (global) — é fundamental para manter o código previsível e fácil de manter.

---

## Estado local

**Estado local** é aquele que pertence a um único componente e é usado apenas por ele (e eventualmente por seus filhos via props).

- **Onde usar**: inputs de formulário, modais abertos/fechados, accordion expandido, dados carregados que só uma tela usa.
- **Como implementar**: `useState` (ou `useReducer`) dentro do componente.
- **Vantagens**: isolamento, sem risco de efeitos colaterais em outras partes da árvore, fácil de entender.

Exemplo: o valor de um campo de busca usado só na mesma página deve ser estado local.

---

## Estado global (compartilhado)

**Estado global** é aquele que precisa ser acessado por vários componentes em níveis diferentes da árvore, sem passar props por muitos níveis (prop drilling).

- **Onde usar**: usuário logado, tema (claro/escuro), idioma, carrinho de compras, notificações globais.
- **Como implementar**: Context API (`createContext` + `Provider` + `useContext`), ou bibliotecas como Redux, Zustand, Jotai.
- **Cuidados**: quando o contexto muda, todos os consumidores re-renderizam; para estado que muda com muita frequência ou é muito grande, considere dividir contextos ou usar uma lib de estado.

Regra prática: comece com estado local; só eleve para global quando mais de um ramo da árvore precisar do mesmo dado ou quando prop drilling ficar incômodo.

---

## Quando usar cada um

| Situação | Recomendação |
|----------|--------------|
| Dado usado só no componente ou nos filhos diretos (passando props) | Estado local |
| Dado usado em várias telas ou em componentes distantes na árvore | Estado global (Context ou lib) |
| Formulário com muitos campos e lógica complexa | Local com `useReducer` ou lib de formulário |
| Usuário autenticado, tema, preferências | Global (Context é suficiente em muitos casos) |
| Estado que muda muito ou é muito grande | Global com lib (Zustand, Redux) ou Context dividido |

---

## Conclusão

Estado local resolve a maioria dos casos; estado global deve ser usado com critério para evitar complexidade e re-renders desnecessários. No próximo arquivo veremos a Context API e padrões de uso no React.
