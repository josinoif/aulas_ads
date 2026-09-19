# Travou? Sintoma → ação

Use **antes** de pedir ajuda ao professor. Em conflito de rotas, o [MAPA](MAPA-LINHAS-P-A.md) prevalece.

**Stack:** NestJS 12 — pins em [VERSIONS.md](VERSIONS.md).

**Ordem de recuperação:** este FAQ → [CURLS-P](CURLS-P.md) → [SOLUCAO-P](SOLUCAO-P.md) → capítulo do sintoma.

> **Shell:** comandos são **Bash** (Linux ou **Git Bash** no Windows). Se estiver no PowerShell, abra o **Git Bash** e rode de lá.

| Sintoma | Capítulo típico | Ação |
|---------|-----------------|------|
| Estou no PowerShell / curls quebram | 1+ | Abra **Git Bash** (padrão Windows desta trilha) e rode os mesmos comandos Bash |
| Não tenho Git Bash | 1 | Instale [Git for Windows](https://git-scm.com/download/win) e abra o app **Git Bash** |
| Escolhi ESM/Vitest no scaffold | 1 | Refaça com CLI `@12` e escolha **CJS (CommonJS) [with jest]** — esta trilha não usa Vitest/ESM |
| Node &lt; 20.19 / linha 21.x | 1 | Nest 12 exige **20.19+** ou **22.12+** ([VERSIONS](VERSIONS.md)); atualize o Node |
| `Cannot find module` / peer conflict Nest 10–11 vs 12 / `typeorm@1` | 1, 5, 6, 8 | Releia [VERSIONS.md](VERSIONS.md); reinstale com o `@versão` do capítulo — não misture majors Nest nem puxe `typeorm@1` |
| Cap. 4 e `npm install` TypeORM | 4 | Cap. 4 = **só conceito**; install é no [5](5.crud_nest_bd.md) |
| `docker exec … < seed.sql` falha | 5–6 | Use Bash (Git Bash no Windows); cwd em `backend/nest/`; confira path `seed/seed.sql` |
| `relation "…" does not exist` no seed | 5–6 | Suba a API uma vez (`synchronize: true`), **depois** o seed |
| `productId: 1` → 404 após reseed | 5.1–7 | Seeds: `DELETE` + `ALTER SEQUENCE … RESTART WITH 1`; reaplique [seed/](seed/). SQL antigo só com `DELETE` deixa sequences altas |
| Pedidos “estranhos” após `seed-catalog` | 5.1+ | Não reaplicar só o catalog depois de pedidos; no **cap. 6+** use [`seed.sql`](seed/seed.sql) completo |
| `relation "users" does not exist` no 5.1 | 5.1 | [`seed.sql`](seed/seed.sql) é **só no cap. 6+**; no 5.1 use `seed-catalog` ou o `POST /products` |
| `port is already allocated` / nome `loja-postgres` | 5 | Container já existe: `docker start loja-postgres` (ou `docker ps -a`) — não precisa recriar |
| `nest g` / CLI não acha o projeto | 1+ | Rode **`npx nest g …` dentro de `loja-api/`** |
| `EntityNotFound` / detached no pedido | 5.1 | Dentro da transação use só o `manager` (não misture `repository` solto) — [5.1](5.1.pedidos.md) |
| Pedido sem itens no banco | 5.1 | `@OneToMany(…, { cascade: true })` no `Order` + save pelo `manager` |
| `JWT_SECRET` / `getOrThrow` / Configuration key | 6 | `.env` em **`loja-api/`** (cópia de [`.env.example`](.env.example)); reinicie `start:dev` |
| POST produto sem token → ? | 6–7 | Cap. 6: **401**; após roles (7), Cli autenticado em POST produto → **403** |
| Cli cria produto no cap. 6 | 6 | Esperado até o cap. 7 (só JWT); ADMIN-only vem no [7](7.autorizacao.md) |
| `@Roles('ADMIN')` e Cli ainda cria (201) | 7 | Falta `RolesGuard` no `@UseGuards(JwtAuthGuard, RolesGuard)` — só `@Roles` não bloqueia |
| Guard / strategy “não resolve” (DI) | 6–7 | `ProductsModule` / `OrdersModule` devem **importar** `AuthModule` (exporta guards) |
| `PassportModule` solto / AuthModuleOptions | 6 | Use `PassportModule.register({ defaultStrategy: 'jwt' })` — não `PassportModule` sem `.register` |
| `TOKEN=$(curl … \| python …)` falha | 6–9 | No Linux tente `python3`; ou `jq -r .access_token`; ou token manual ([CURLS-P](CURLS-P.md) opção C) |
| `bash seed/verify-seed.sh` | 6, 10 | Rode no Git Bash / Linux a partir de `backend/nest/` |
| `bash scripts/e2e-prepare.sh` | 10 | Preferível em `backend/nest/`; de `loja-api/` use `bash ../scripts/e2e-prepare.sh`. **Pare** `start:dev` (porta 3000) |
| Jest falha com ESM / `import` em `@nestjs/*` | 10 | Scripts: `node --experimental-vm-modules ./node_modules/jest/bin/jest.js` ([cap. 10](10.testes_software.md)) |
| E2e aceita body inválido | 10 | Espelhe o `ValidationPipe` do `main.ts` no app de teste |
| Upload `multer` conflitando | 9 | **Não** `npm install multer`; só `@types/multer@2.0.0` (Nest 12 já traz multer 2.x via `platform-express`) |
| Validação não dispara | 2.1 | DTO tem que ser **classe** + `ValidationPipe` global no `main.ts` |
| TypeORM `id` estranho / NaN | 3, 5 | `@Param('id', ParseIntPipe)` — intro no [3](3.services.md), crítico no [5](5.crud_nest_bd.md) · [REFERENCIA §2](REFERENCIA-NEST.md#sec-pipes) |
| `price` / `unitPrice` “mudou de tipo” no JSON | 5, 10 | Coluna `numeric` pode vir como **string** — normal; no e2e use `Number(…)` |
| Erro de propriedade não inicializada no TS | 1+ | Scaffold Nest 12 CJS usa `strictPropertyInitialization: false` — não force `true` sem ajustar entidades/DTOs |
| Esqueci qual decorator usar | 2–9 | [REFERENCIA-NEST.md](REFERENCIA-NEST.md#sec-http) (por objetivo; Ctrl+F no índice) |

Checklist rápido de fechamento: [SOLUCAO-P.md](SOLUCAO-P.md).  
Cheat sheet de symbols: [REFERENCIA-NEST.md](REFERENCIA-NEST.md).
