# Versões oficiais da trilha Nest (`loja-api`)

Use **estes pins**. Sem `@versão`, o npm pode puxar majors incompatíveis (ex.: `typeorm@1`).

Cole na descrição do vídeo / chat da turma se alguém perguntar “qual versão?”:

```text
NestJS 12 · CLI @12 · Node 20.19+ ou 22.12+ · PostgreSQL 16 · TypeScript 6
Scaffold: escolha CJS (CommonJS + Jest) — não ESM/Vitest nesta trilha
class-validator@0.14.1 · class-transformer@0.5.1
@nestjs/typeorm@12.0.1 · typeorm@0.3.31 · pg@8.13.3 · @nestjs/config@12.0.0
@nestjs/jwt@12.0.2 · @nestjs/passport@12.0.0 · passport@0.7.0 · passport-jwt@4.0.1 · bcryptjs@2.4.3
@nestjs/swagger@12.0.1 · @nestjs/mapped-types@12.0.0
@types/multer@2.0.0 (dev) — não instale multer solto (Nest 12 já traz multer 2.x)
Jest 30 · scripts: node --experimental-vm-modules ./node_modules/jest/bin/jest.js (cap. 10)
```

## Tabela completa

| Pacote / peça | Versão | Capítulo |
|---------------|--------|----------|
| Node.js | **20.19+** ou **22.12+** (Nest 12; não use 21.x) | pré-req |
| TypeScript | **6.0.3** (CLI 12 puxa ~6) | 1 |
| `@nestjs/cli` (scaffold) | **12** (`npx @nestjs/cli@12 new …`) | 1 |
| Módulo do scaffold | **CJS** (prompt: CommonJS + Jest) | 1 |
| `@nestjs/common` / `core` / `platform-express` | **12.0.3** | 1 |
| `class-validator` | **0.14.1** | 2.1 |
| `class-transformer` | **0.5.1** | 2.1 |
| `@nestjs/mapped-types` | **12.0.0** | 2.1 (desafio A) |
| `@nestjs/typeorm` | **12.0.1** | 5 (prévia no 4) |
| `typeorm` | **0.3.31** (**não** use 1.x) | 5 (prévia no 4) |
| `pg` | **8.13.3** | 5 (prévia no 4) |
| `@nestjs/config` | **12.0.0** | 5–6 |
| `@nestjs/jwt` | **12.0.2** | 6 |
| `@nestjs/passport` | **12.0.0** | 6 |
| `passport` | **0.7.0** | 6 |
| `passport-jwt` | **4.0.1** | 6 |
| `bcryptjs` | **2.4.3** | 6 |
| `@types/passport-jwt` | **4.0.1** (dev) | 6 |
| `@types/bcryptjs` | **2.4.6** (dev) | 6 |
| `@nestjs/swagger` | **12.0.1** | 8 |
| `@types/multer` | **2.0.0** (dev) | 9 |
| Jest | **30** + `--experimental-vm-modules` nos scripts | 10 |
| Postgres (Docker) | `postgres:16-alpine` | Compose |
| pgAdmin (Docker) | `dpage/pgadmin4:8` | Compose |

## Comandos (copie do capítulo, não invente)

Os `npm install …@versão` estão **ao lado** da instalação em cada capítulo. Se omitir o `@versão`, o lab pode quebrar.

Após criar o projeto, confira:

```bash
cd loja-api
node -p "require('./package.json').dependencies['@nestjs/common']"
# esperado: 12.0.3 (ou ^12.x do scaffold)
```

**Nota Nest 12:** pacotes `@nestjs/*` são ESM, mas o app **CJS** continua funcionando via `require(esm)` no Node 20.19+/22.12+. Esta trilha **não** migra para Vitest/ESM.

Cheat sheet: [`REFERENCIA-NEST.md`](REFERENCIA-NEST.md). Travou? [`FAQ-TRAVOU.md`](FAQ-TRAVOU.md).
