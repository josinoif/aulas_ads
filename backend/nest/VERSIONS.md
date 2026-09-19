# Versões oficiais da trilha Nest (`loja-api`)

Use **estes pins**. O npm “latest” do Nest já está na linha **12** e quebra os exemplos deste material.

Cole na descrição do vídeo / chat da turma se alguém perguntar “qual versão?”:

```text
NestJS 10 · CLI @10 · PostgreSQL 16
class-validator@0.14.1 · class-transformer@0.5.1
@nestjs/typeorm@10.0.2 · typeorm@0.3.26 · pg@8.13.3 · @nestjs/config@3.3.0
@nestjs/jwt@10.2.0 · @nestjs/passport@10.0.3 · passport@0.7.0 · passport-jwt@4.0.1 · bcryptjs@2.4.3
@nestjs/swagger@8.1.1 · @nestjs/mapped-types@2.0.6
@types/multer@1.4.12 (dev) — não instale multer solto
```

## Tabela completa

| Pacote / peça | Versão | Capítulo |
|---------------|--------|----------|
| Node.js | **20 LTS** (mín. 18) | pré-req |
| `@nestjs/cli` (scaffold) | **10** (`npx @nestjs/cli@10 new …`) | 1 |
| `@nestjs/common` / `core` / `platform-express` | **10.x** (via CLI) | 1 |
| `class-validator` | **0.14.1** | 2.1 |
| `class-transformer` | **0.5.1** | 2.1 |
| `@nestjs/mapped-types` | **2.0.6** | 2.1 (desafio A) |
| `@nestjs/typeorm` | **10.0.2** | 5 (prévia no 4) |
| `typeorm` | **0.3.26** (não use 1.x) | 5 (prévia no 4) |
| `pg` | **8.13.3** | 5 (prévia no 4) |
| `@nestjs/config` | **3.3.0** | 5–6 |
| `@nestjs/jwt` | **10.2.0** | 6 |
| `@nestjs/passport` | **10.0.3** | 6 |
| `passport` | **0.7.0** | 6 |
| `passport-jwt` | **4.0.1** | 6 |
| `bcryptjs` | **2.4.3** | 6 |
| `@types/passport-jwt` | **4.0.1** (dev) | 6 |
| `@types/bcryptjs` | **2.4.6** (dev) | 6 |
| `@nestjs/swagger` | **8.1.1** | 8 |
| `@types/multer` | **1.4.12** (dev) | 9 |
| Postgres (Docker) | `postgres:16-alpine` | Compose |
| pgAdmin (Docker) | `dpage/pgadmin4:8` | Compose |

## Comandos (copie do capítulo, não invente)

Os `npm install …@versão` estão **ao lado** da instalação em cada capítulo. Se omitir o `@versão`, o lab pode quebrar.

Após criar o projeto, confira:

```bash
cd loja-api
node -p "require('./package.json').dependencies['@nestjs/common']"
# esperado: algo como ^10.0.0
```

Cheat sheet de decorators/pipes da linha P: [`REFERENCIA-NEST.md`](REFERENCIA-NEST.md). Travou? [`FAQ-TRAVOU.md`](FAQ-TRAVOU.md).