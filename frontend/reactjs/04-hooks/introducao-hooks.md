# Introdução aos Hooks

## O que são Hooks?

**Hooks** são funções especiais do React que permitem "conectar" recursos como estado e ciclo de vida a componentes funcionais. Eles foram introduzidos na versão 16.8 (2019) e passaram a ser a forma recomendada de escrever componentes em React, substituindo em muitos casos os componentes de classe.

Antes dos hooks, componentes funcionais não tinham estado próprio nem acesso direto a métodos de ciclo de vida; quem precisava disso usava classes. Com os hooks, você continua usando funções e ganha estado, efeitos colaterais e outras capacidades de forma consistente e reutilizável.

---

## Por que Hooks?

- **Reutilização de lógica**: Lógica de estado ou efeitos pode ser extraída em hooks customizados (ex.: `useAuth`, `useFetch`) e reaproveitada em vários componentes.
- **Organização**: Em vez de espalhar lógica em `componentDidMount`, `componentDidUpdate` etc., você agrupa por responsabilidade em um ou mais `useEffect`.
- **Menos boilerplate**: Não é necessário usar `this`, `bind` ou classes; o código tende a ser mais direto.
- **Adoção da comunidade**: A documentação e a maioria dos tutoriais e bibliotecas assumem componentes funcionais e hooks.

---

## Regras dos Hooks

O React exige que os hooks sejam usados de forma previsível. Duas regras importantes:

1. **Chame hooks apenas no nível superior**: Não use hooks dentro de loops, condicionais ou funções aninhadas. Assim, a ordem das chamadas é sempre a mesma a cada renderização.
2. **Chame hooks apenas em componentes React ou em custom hooks**: Ou seja, dentro de uma função de componente ou de uma função que comece com `use` e que chame outros hooks.

Respeitar essas regras garante que o React associe corretamente cada chamada ao estado interno do componente.

---

## Hooks principais

| Hook | Uso principal |
|------|----------------|
| **useState** | Estado local (valor + setter). |
| **useEffect** | Efeitos colaterais: fetch, subscriptions, timers, limpeza ao desmontar. |
| **useReducer** | Estado mais complexo com lógica de atualização centralizada. |
| **useMemo** | Memorizar um valor calculado (evitar recálculo a cada render). |
| **useCallback** | Memorizar uma função (evitar recriação e re-renders desnecessários). |
| **useContext** | Consumir um contexto (dados compartilhados sem prop drilling). |

Outros hooks úteis: `useRef`, `useImperativeHandle`, `useLayoutEffect`. Hooks customizados são funções que usam um ou mais desses hooks e encapsulam lógica reutilizável.

---

## Conclusão

Hooks são a base do React moderno. Entender as regras de uso e o papel de cada hook principal permite escrever componentes funcionais poderosos e fáceis de manter. Nos arquivos seguintes você verá a teoria e os casos de uso de cada hook; no [tutorial-hooks.md](tutorial-hooks.md) colocará vários deles em prática em um único exemplo.
