# Seed oficial — `loja-api`

Dados mínimos da **linha P** para lab e testes.

| Usuário | Senha | Role |
|---------|-------|------|
| `ana` | `secret123` | `ADMIN` (dona da loja) |
| `cli` | `secret123` | `CLIENT` |

Produtos: **Caneca Nest** (stock 10), **Camiseta ADS** (stock 25).

## Qual arquivo usar

| Arquivo | Quando |
|---------|--------|
| [`seed-catalog.sql`](seed-catalog.sql) | Após cap. **5** (só tabela `products`) |
| [`seed.sql`](seed.sql) | Após caps. **5.1 + 6** (tabelas `orders` / `order_items` / `users`) |

## Como aplicar

Compose: [`docker-compose.postgres.yml`](../docker-compose.postgres.yml). Verificação: [`verify-seed.sh`](verify-seed.sh).

```bash
# a partir de backend/nest/
docker compose -f docker-compose.postgres.yml up -d

# só catálogo (cap. 5):
docker exec -i loja-postgres psql -U loja -d loja < seed/seed-catalog.sql

# seed completo (auth + pedidos):
docker exec -i loja-postgres psql -U loja -d loja < seed/seed.sql
bash seed/verify-seed.sh
```

**PowerShell:**

```powershell
Get-Content .\seed\seed-catalog.sql | docker exec -i loja-postgres psql -U loja -d loja
Get-Content .\seed\seed.sql         | docker exec -i loja-postgres psql -U loja -d loja
```

> **[`seed.sql`](seed.sql) / [`seed-catalog.sql`](seed-catalog.sql)** usam **`DELETE`** + **`ALTER SEQUENCE … RESTART WITH 1`**.  
> Só `DELETE` apaga linhas, mas **não** zera o contador `SERIAL` — sem o `ALTER SEQUENCE`, o próximo `INSERT` vira id `3+` e os curls com `productId: 1` falham.  
> O seed completo **apaga** produtos, usuários e pedidos existentes (inclui pedidos de teste do cap. 5.1) — use de propósito no cap. 6+.  
> **`seed-catalog` só no cap. 5:** depois de pedidos, não reaplicar só o catalog (pode deixar itens órfãos). Use `seed.sql`.

A API precisa ter subido ao menos uma vez com `synchronize: true` para criar as tabelas.

## Verificação

```bash
bash seed/verify-seed.sh
# OK: seed.sql verificado (ana/cli → secret123)

# PowerShell:
# .\seed\verify-seed.ps1
```

## Personagens

- **Ana** — administra catálogo (criar/editar produto, upload).  
- **Cli** — compra (pedidos).

Usados nos curls de [`CURLS-P.md`](../CURLS-P.md) e nos caps. de auth/roles/testes.  
Travou no seed? [`FAQ-TRAVOU.md`](../FAQ-TRAVOU.md).
