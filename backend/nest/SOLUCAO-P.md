# Gabarito de verificação — linha P (`loja-api`)

Não substitui implementar capítulo a capítulo. Use quando estiver travado: compare **comportamento HTTP** e **arquivos tocados** com o esperado abaixo.

**Stack da trilha:** NestJS 12 + TypeORM + PostgreSQL 16 ([VERSIONS.md](VERSIONS.md)).

Contrato canônico: [MAPA-LINHAS-P-A.md](MAPA-LINHAS-P-A.md). Curls: [CURLS-P.md](CURLS-P.md).

```mermaid
flowchart LR
    Travou[Travou?] --> Mapa[MAPA contrato]
    Mapa --> Curls[CURLS-P]
    Curls --> Sol[SOLUCAO-P este arquivo]
    Sol --> Cap[voltar ao capítulo]
```

---

## Por capítulo — o que deve funcionar

| Cap. | Verificação rápida |
|------|-------------------|
| **1** | `GET /health` → `200` `{ "status": "ok" }` |
| **2** | CRUD `/products` em memória; `POST` → `201`; `DELETE` → `204`; id inexistente → `404` |
| **2.1** | `POST /products` com `price: "barato"` → **400**; `ValidationPipe` em `main.ts` |
| **3** | Mesmos curls do cap. 2; lógica no `ProductsService` |
| **4** | Só leitura conceitual — **nenhum curl novo**; entenda entidade × DTO e Postgres antes do cap. 5 |
| **5** | Produto sobrevive restart; Postgres via Docker |
| **5.1** | `POST /orders` debita `stock`; cancel devolve estoque; estoque insuficiente → **400** |
| **6** | **6a:** seed + login → `access_token` · **6b:** `POST /products` sem token → **401**; **qualquer** Bearer (Ana **ou** Cli) → **201** (ADMIN-only = cap. 7) |
| **7** | Cli em `POST /products` → **403**; Ana → **201**; Cli em `POST /orders` → **201** |
| **8** | `GET /api` abre Swagger; Authorize com JWT |
| **9** | Ana upload imagem → **200**; Cli upload → **403**; MIME inválido → **400** |
| **10** | `npm test` + `npm run test:e2e` (scripts com `node --experimental-vm-modules …/jest/bin/jest.js`; após `bash scripts/e2e-prepare.sh`) |

---

## Árvore mínima esperada (caps. 6–7)

```text
loja-api/src/
  main.ts
  app.module.ts
  products/
    product.entity.ts
    products.module.ts
    products.service.ts
    products.controller.ts
    dto/create-product.dto.ts
    dto/update-product.dto.ts
  orders/
    order.entity.ts
    order-item.entity.ts
    orders.module.ts
    orders.service.ts
    orders.controller.ts
    dto/create-order.dto.ts
  auth/
    user.entity.ts
    auth.module.ts
    auth.service.ts
    auth.controller.ts
    jwt.strategy.ts
    jwt-auth.guard.ts
    roles.decorator.ts
    roles.guard.ts
    dto/register.dto.ts
    dto/login.dto.ts
```

---

## Seeds

Arquivos: [`seed/seed.sql`](seed/seed.sql), [`seed/verify-seed.sh`](seed/verify-seed.sh).

```bash
# backend/nest/ (Bash — Linux ou Git Bash no Windows)
docker exec -i loja-postgres psql -U loja -d loja < seed/seed.sql
bash seed/verify-seed.sh
```

Login de lab: `ana` / `cli` → senha `secret123`. Seeds: `DELETE` + `ALTER SEQUENCE … RESTART WITH 1` → ids voltam a 1.

---

## Chaves rápidas dos checkpoints (professor / autoestudo)

| Cap. | Ideia-chave |
|------|-------------|
| 1 | Nest organiza API; `/health` prova que o processo sobe |
| 2.1 | Tipagem TS ≠ validação HTTP; pipe + DTO **classe** |
| 5 | Mesma URL, outro miolo (RAM → Postgres); `ParseIntPipe` no `:id` (intro no cap. 3) |
| 5.1 | Transação: pedido + estoque juntos ou nada |
| 6 | Autenticação = quem é; JWT no Bearer; **6a** (token) antes de **6b** (guards) |
| 7 | 401 sem identidade; 403 sem papel |
| 10 | Unitário isola; e2e repete o `ValidationPipe` do `main.ts` |

Nos checkpoints dos capítulos duros (5.1, 6, 7, 10): use esta tabela como **chave** (1 frase por pergunta). Sem código pronto.

Travou? [`FAQ-TRAVOU.md`](FAQ-TRAVOU.md). Versões? [`VERSIONS.md`](VERSIONS.md).  
Esqueceu um decorator? [`REFERENCIA-NEST.md`](REFERENCIA-NEST.md).  
**Shell:** Bash (Linux ou Git Bash no Windows) — [CURLS-P](CURLS-P.md).

---

## O que esta trilha **não** inclui

- Repositório com código-fonte completo da solução (você constrói no `loja-api`).
- Pacotes da linha A (capstone em [exercicio-1.md](exercicio-1.md)).

Professores podem publicar um branch `solucao-p` no repositório da turma espelhando esta árvore.  
Prepare e2e: [`scripts/e2e-prepare.sh`](scripts/e2e-prepare.sh).
