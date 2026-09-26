# Diagramas da solução — loja-api (trilha NestJS, linha P)

Complementa o `openapi.json`: descreve graficamente os fluxos que a API implementa do cap. 1 ao cap. 9. Cada bloco é um diagrama Mermaid independente — abra num visualizador Mermaid (mermaid.live, extensão do VS Code, ou qualquer app que renderize ```mermaid) ou cole direto num doc/markdown que já renderiza Mermaid.

## 1. Arquitetura geral

Visão de componentes: onde cada módulo vive e com o que ele fala.

```mermaid
flowchart TD
  Cli["Cliente HTTP<br/>(curl / Swagger UI)"] -->|"JSON ou multipart"| API["loja-api (NestJS)"]

  subgraph API["loja-api (NestJS)"]
    direction TB
    AuthM["AuthModule<br/>(register, login, guards)"]
    ProdM["ProductsModule<br/>(catálogo + imagem)"]
    OrdM["OrdersModule<br/>(pedidos)"]
  end

  AuthM -.->|"JwtAuthGuard / RolesGuard"| ProdM
  AuthM -.->|"JwtAuthGuard"| OrdM
  OrdM -->|"lê produto via manager<br/>(mesma transação)"| ProdM

  ProdM --> PG[("PostgreSQL<br/>products, users, orders, order_items")]
  OrdM --> PG
  AuthM --> PG
  ProdM -->|"bytes da imagem"| FS[("Disco local<br/>uploads/*.jpg")]
```

## 2. Persistência de produtos (cap. 5): padrão Repository

O cap. 5 troca o array em memória pelo `Repository<Product>` do TypeORM — cada método do service vira uma chamada direta ao repositório, sem transação manual (compare com o diagrama 6, onde criar um pedido precisa do `manager` dentro de uma transação).

```mermaid
sequenceDiagram
  actor Cli as Cliente HTTP
  participant Ctrl as ProductsController
  participant Svc as ProductsService
  participant Repo as "Repository(Product)"
  participant DB as PostgreSQL

  Note over Repo: injetado no service com @InjectRepository(Product)

  Cli->>Ctrl: GET /products
  Ctrl->>Svc: findAll()
  Svc->>Repo: repository.find()
  Repo->>DB: SELECT * FROM products
  DB-->>Svc: Product[]
  Svc-->>Ctrl: Product[]
  Ctrl-->>Cli: 200 Product[]

  Cli->>Ctrl: GET /products/:id
  Ctrl->>Svc: findOne(id)
  Svc->>Repo: repository.findOne({ where: { id } })
  Repo->>DB: SELECT ... WHERE id = ?
  DB-->>Svc: Product ou null
  Note over Svc: null → lança NotFoundException (404)
  Svc-->>Ctrl: Product
  Ctrl-->>Cli: 200 Product (ou 404)

  Cli->>Ctrl: POST /products { name, price, stock }
  Ctrl->>Svc: create(dto)
  Svc->>Repo: repository.create(dto)
  Note over Repo: só monta a instância em memória, nada no banco ainda
  Svc->>Repo: repository.save(product)
  Repo->>DB: INSERT INTO products ...
  DB-->>Svc: Product (com id gerado)
  Svc-->>Ctrl: Product
  Ctrl-->>Cli: 201 Product

  Cli->>Ctrl: PUT /products/:id { name, price, stock }
  Ctrl->>Svc: update(id, dto)
  Svc->>Repo: findOne(id) + Object.assign(product, dto)
  Svc->>Repo: repository.save(product)
  Repo->>DB: UPDATE products SET ...
  Svc-->>Ctrl: Product atualizado
  Ctrl-->>Cli: 200 Product

  Cli->>Ctrl: DELETE /products/:id
  Ctrl->>Svc: remove(id)
  Svc->>Repo: repository.delete(id)
  Repo->>DB: DELETE FROM products WHERE id = ?
  DB-->>Svc: { affected: 0 ou 1 }
  Note over Svc: affected = 0 → NotFoundException (404)
  Ctrl-->>Cli: 204 (ou 404)
```

## 3. Modelo de dados (ER)

As quatro entidades da linha P e como se relacionam.

```mermaid
erDiagram
  USER ||--o{ ORDER : "faz (userId)"
  ORDER ||--|{ ORDER_ITEM : "contém"
  PRODUCT ||--o{ ORDER_ITEM : "referenciado por"

  USER {
    int id PK
    string username
    string email
    string password "hash bcrypt"
    string role "CLIENT | ADMIN"
  }
  PRODUCT {
    int id PK
    string name
    numeric price
    int stock
    string imageFilename "nullable, cap 9"
  }
  ORDER {
    int id PK
    int userId FK "nullable até cap 6"
    string status "OPEN | CANCELLED"
    datetime createdAt
  }
  ORDER_ITEM {
    int id PK
    int orderId FK
    int productId FK
    int quantity
    numeric unitPrice "preço congelado (snapshot)"
  }
```

## 4. Autenticação: registro, login e requisição protegida

Assim como o cap. 5 (diagrama 2), o cap. 6 também acessa o banco via `Repository<User>` — nunca via `manager`. Só o cap. 5.1/20 (diagrama 6) usa `manager`, porque só ali existe uma transação multi-tabela de verdade.

```mermaid
sequenceDiagram
  actor Cli as Cliente
  participant Ctrl as AuthController
  participant Svc as AuthService
  participant Repo as "Repository(User)"
  participant DB as PostgreSQL
  participant Jwt as JwtService
  participant Strat as JwtStrategy

  Note over Repo: injetado no service com @InjectRepository(User)

  Cli->>Ctrl: POST /auth/register { username, email, password }
  Ctrl->>Svc: register(username, email, password)
  Svc->>Repo: usersRepository.findOne({ where: [username, email] })
  Repo->>DB: SELECT ... WHERE username = ? OR email = ?
  DB-->>Svc: já existe?
  Note over Svc: se existir → ConflictException (409)
  Svc->>Svc: bcrypt.hash(password, 10)
  Svc->>Repo: usersRepository.create(...) + save(...)
  Repo->>DB: INSERT INTO users (role = CLIENT)
  DB-->>Svc: User salvo
  Svc-->>Ctrl: User sem o campo password
  Ctrl-->>Cli: 201 PublicUser

  Cli->>Ctrl: POST /auth/login { username, password }
  Ctrl->>Svc: login(username, password)
  Svc->>Repo: usersRepository.findOne({ where: { username } })
  Repo->>DB: SELECT ... WHERE username = ?
  DB-->>Svc: User ou undefined
  Svc->>Svc: bcrypt.compare(password, user.password)
  Note over Svc: falhou → UnauthorizedException (401)
  Svc->>Jwt: jwtService.signAsync({ sub, username, role })
  Jwt-->>Svc: access_token
  Svc-->>Ctrl: { access_token }
  Ctrl-->>Cli: 200 { access_token }

  Cli->>Strat: qualquer rota protegida<br/>Authorization: Bearer token
  Strat->>Strat: valida assinatura (JWT_SECRET) e expiração
  Strat-->>Cli: request.user = { userId, username, role }
```

## 5. Pipeline de autorização (guards)

A diferença prática entre 401 e 403, no formato que os guards checam.

```mermaid
flowchart LR
  Req["Requisição<br/>+ header Authorization?"] --> G1{"JwtAuthGuard:<br/>token válido?"}
  G1 -->|"não"| E401["401 Unauthorized<br/>(não sabemos quem é)"]
  G1 -->|"sim"| G2{"RolesGuard:<br/>@Roles bate com<br/>request.user.role?"}
  G2 -->|"não"| E403["403 Forbidden<br/>(sabemos quem é,<br/>não pode fazer isso)"]
  G2 -->|"sim ou<br/>sem @Roles"| Handler["Handler do controller"]
```

## 6. Criar pedido (transação, snapshot de preço, baixa de estoque)

O fluxo mais importante do curso — tudo ou nada. Repara a diferença pro diagrama 2: aqui o acesso ao banco passa pelo `manager` de uma transação explícita, nunca pelo repositório normal — porque essa operação mexe em `Order`, `OrderItem` e `Product` ao mesmo tempo, e precisa de tudo-ou-nada.

```mermaid
sequenceDiagram
  actor Cli as Cliente autenticado
  participant Ctrl as OrdersController
  participant Svc as OrdersService
  participant TX as Transação (manager)
  participant DB as Postgres

  Cli->>Ctrl: POST /orders {items:[{productId, quantity}]}
  Ctrl->>Svc: create(dto, userId do token)
  Svc->>TX: dataSource.transaction(async manager => ...)
  loop para cada item do pedido
    TX->>DB: manager.findOne(Product, id)
    alt produto não existe
      TX-->>Cli: 404 (rollback automático)
    else quantidade > estoque
      TX-->>Cli: 400 estoque insuficiente (rollback automático)
    else ok
      TX->>DB: manager.decrement(Product, stock, quantity)
      TX->>TX: unitPrice = product.price (snapshot agora)
    end
  end
  TX->>DB: manager.save(Order + OrderItem[]) (cascade)
  DB-->>TX: commit
  TX-->>Cli: 201 Order (status OPEN)
```

## 7. Ciclo de vida do pedido

```mermaid
stateDiagram-v2
  [*] --> OPEN: POST /orders
  OPEN --> CANCELLED: POST /orders/:id/cancel<br/>(devolve estoque em transação)
  OPEN --> PAID: desafio opcional<br/>(não implementado na linha P)
  CANCELLED --> [*]
  PAID --> [*]
  note right of OPEN
    Só OPEN muda de estado.
    A linha P só implementa a
    transição pra CANCELLED;
    PAID é o desafio opcional
    do capítulo.
  end note
```

## 8. Upload e download de imagem do produto

```mermaid
sequenceDiagram
  actor Ana as Ana (ADMIN)
  actor Qualquer as Qualquer cliente
  participant Ctrl as ProductsController
  participant Multer as Multer (fileFilter)
  participant FS as Disco (uploads/)
  participant DB as Postgres

  Ana->>Ctrl: POST /products/:id/image (multipart, campo "file")
  Ctrl->>Multer: valida MIME (jpeg/png/webp) e tamanho (≤2MB)
  alt MIME inválido ou arquivo ausente
    Multer-->>Ana: 400
  else ok
    Multer->>FS: grava bytes em uploads/<timestamp>-nome.jpg
    Ctrl->>DB: updateImageFilename(id, filename)
    Ctrl-->>Ana: 200 { productId, imageUrl }
  end

  Qualquer->>Ctrl: GET /products/:id/image (rota pública)
  Ctrl->>DB: busca product.imageFilename
  Ctrl->>FS: createReadStream(uploads/<filename>)
  FS-->>Qualquer: stream dos bytes da imagem
```
