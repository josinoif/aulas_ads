# Referência rápida — Nest na `loja-api` (linha P)

> **Consulta, não capítulo.** Não leia de ponta a ponta — use a tabela abaixo ou Ctrl+F no mini-índice.  
> **Primeira vez no assunto?** Volte ao capítulo da coluna Cap. — esta folha não substitui o tutorial.  
> **Folha = nomes.** Sintoma (erro, NaN, “não valida”)? → [FAQ-TRAVOU.md](FAQ-TRAVOU.md).  
> **Escopo:** Nest 12 + TypeORM da trilha. Cap. `—` / *extra* = fora da linha P (docs).  
> **Versões:** [VERSIONS.md](VERSIONS.md).

Agrupado por **objetivo / ordem da trilha** (não é o ciclo de vida interno do Nest: guards rodam antes de pipes).

| # | Objetivo | Capítulos |
|---|----------|-----------|
| 1 | [Controller / HTTP](#sec-http) | 2–3 (+ `@Req` no 6) |
| 2 | [Pipes e validação](#sec-pipes) | 2.1, 5, 5.1 |
| 3 | [Guards e autorização](#sec-guards) | 6–7 |
| 4 | [DI e módulos](#sec-di) | 3, 5–7 |
| 5 | [TypeORM / persistência](#sec-typeorm) | 4–5.1, 6 |
| 6 | [Auth (JWT / Passport)](#sec-auth) | 6–7 |
| 7 | [Swagger / OpenAPI](#sec-swagger) | 8–9 |
| 8 | [Upload (Multer)](#sec-upload) | 9 |

Validação detalhada (`class-validator`): apêndice do [2.1](2.1.dtos-e-validacao.md#6-principais-decorators-do-class-validator-consulta) — **não** duplicado aqui.

---

<a id="sec-http"></a>

## 1. Controller / HTTP

Pacote: `@nestjs/common` · Docs: [Controllers](https://docs.nestjs.com/controllers)

| Símbolo | Quando usar | Mini exemplo | Cap. |
|---------|-------------|--------------|------|
| `@Controller('path')` | Prefixo de rotas do recurso | `@Controller('products')` | 2 |
| `@Get()` `@Post()` `@Put()` `@Delete()` | Verbos HTTP da linha P | `@Get(':id')` | 2 |
| `@Patch()` | Atualização parcial | com `PartialType` | 2.1 **A** |
| `@Body()` | Corpo JSON → parâmetro | `create(@Body() dto: CreateProductDto)` | 2, 2.1 |
| `@Param('id')` | Segmento da URL | `@Param('id', ParseIntPipe) id: number` | 3, 5 |
| `@Query()` | Query string | `list(@Query() q: ListDto)` | 2.1 **A** |
| `@Req()` | Request inteira (ex.: `user` do JWT) | `create(@Req() req: { user: … })` | 6–7 |
| `@Res()` | Resposta Express manual (raro na P) | preferir `StreamableFile` no upload | 9 *alt* |
| `@HttpCode(n)` | Status quando o Nest default não basta | `@HttpCode(204)` no DELETE; `200` no upload | 2, 9 |
| `StreamableFile` | Stream de arquivo sem bypass do Nest | `GET …/image` | 9 |
| `@Header()` | Header de resposta | — | *extra* |

Exceções HTTP comuns na linha P: `NotFoundException`, `BadRequestException`, `ConflictException`, `UnauthorizedException`, `ForbiddenException` (`@nestjs/common`).

---

<a id="sec-pipes"></a>

## 2. Pipes e validação

Pacotes: `@nestjs/common`, `class-validator`, `class-transformer` · Docs: [Pipes](https://docs.nestjs.com/pipes)

| Símbolo | Quando usar | Mini exemplo | Cap. |
|---------|-------------|--------------|------|
| `ValidationPipe` (global) | Validar DTOs de rede | `useGlobalPipes(new ValidationPipe({…}))` — detalhe no 2.1 | 2.1 |
| `ParseIntPipe` | `:id` string → `number` (evita NaN no TypeORM) | `@Param('id', ParseIntPipe) id: number` | 3, 5 |
| `@IsString()` `@MinLength()` `@IsNumber()` `@IsInt()` `@Min()` `@Max()` `@IsOptional()` | Regras no DTO | ver [2.1 §6](2.1.dtos-e-validacao.md#6-principais-decorators-do-class-validator-consulta) | 2.1 |
| `@IsEmail()` `@IsEnum()` | Auth / roles tipados | register / `role` | 6–7 |
| `@IsArray()` `@ValidateNested()` `@Type()` | Body aninhado (itens do pedido) | `CreateOrderDto` | 5.1 |
| `@UsePipes()` | Pipe só em um handler | raro se o global basta | 2.1 |
| `ParseBoolPipe` `ParseUUIDPipe` `DefaultValuePipe` | Outros parsers | — | *extra* |

**Diagnóstico:** pipe “não dispara” → DTO tem que ser **classe** (não `interface` / tipo inline) + `ValidationPipe` global no `main.ts`. Sintoma na FAQ.

---

<a id="sec-guards"></a>

## 3. Guards e autorização

Pacotes: `@nestjs/common`, `@nestjs/core`, `@nestjs/passport` · Docs: [Guards](https://docs.nestjs.com/guards)

| Símbolo | Quando usar | Mini exemplo | Cap. |
|---------|-------------|--------------|------|
| `@UseGuards(...)` | Exigir autenticação/autorização na rota | `@UseGuards(JwtAuthGuard, RolesGuard)` | 6–7 |
| `JwtAuthGuard` | Bearer JWT válido → `request.user` | mutações / pedidos | 6 |
| `RolesGuard` + `@Roles('ADMIN')` | Papel após autenticar | só Ana cria produto | 7 |
| `@SetMetadata` / `Reflector` | Base do `@Roles` | `roles.decorator.ts` | 7 |
| `AuthGuard('jwt')` | Classe base Passport | `extends AuthGuard('jwt')` | 6 |

**Lembrete:** sem token → **401**; token ok sem papel → **403**.

---

<a id="sec-di"></a>

## 4. DI e módulos

Pacote: `@nestjs/common` · Docs: [Providers](https://docs.nestjs.com/providers) · [Modules](https://docs.nestjs.com/modules)

| Símbolo | Quando usar | Mini exemplo | Cap. |
|---------|-------------|--------------|------|
| `@Injectable()` | Classe injetável (service, strategy, guard) | `export class ProductsService` | 3 |
| `@Module({ imports, controllers, providers, exports })` | Agrupar o domínio | `ProductsModule` | 2–3 |
| constructor DI | Pedir dependência ao container | `constructor(private readonly svc: ProductsService)` | 3 |
| `exports: […]` | Outro módulo usa o provider | `AuthModule` exporta guards | 6–7 |
| `ConfigModule` / `ConfigService` | Ler `.env` | `forRootAsync` / JWT secret | 5–6 |
| `@InjectRepository(Entity)` | Repository TypeORM tipado | ver [§5](#sec-typeorm) | 5 |
| `@Inject` / `forwardRef` | Token custom / circular | evitar na linha P | *extra* |

---

<a id="sec-typeorm"></a>

## 5. TypeORM / persistência

Pacotes: `typeorm`, `@nestjs/typeorm` · Docs: [TypeORM](https://typeorm.io) · [Nest TypeORM](https://docs.nestjs.com/techniques/database)

| Símbolo | Quando usar | Mini exemplo | Cap. |
|---------|-------------|--------------|------|
| `@Entity('table')` | Classe ↔ tabela | `@Entity('products')` | 5 |
| `@PrimaryGeneratedColumn()` | PK auto | `id: number` | 5 |
| `@Column(...)` | Coluna | `@Column({ length: 120 }) name` | 5–6, 9 |
| `@CreateDateColumn()` | Timestamp automático | `Order.createdAt` | 5.1 |
| `@OneToMany` / `@ManyToOne` | Relação pedido ↔ itens | `Order` / `OrderItem` | 5.1 |
| `TypeOrmModule.forRoot` / `forRootAsync` | Conexão DB | `AppModule` + `ConfigService` | 5 |
| `TypeOrmModule.forFeature([Entity])` | Registrar entidades no módulo | `ProductsModule` | 5 |
| `@InjectRepository(Product)` | Injetar `Repository<Product>` | service | 5 |
| `Repository` | CRUD do recurso | `find`, `save`, `remove` | 5 |
| `DataSource.transaction` + `EntityManager` | Pedido + estoque atômicos | `dataSource.transaction(async (manager) => …)` | 5.1 |
| `synchronize: true` | Lab cria schema | **nunca** produção | 5 |

`id` NaN no banco? → `ParseIntPipe` no controller ([§2](#sec-pipes)).

---

<a id="sec-auth"></a>

## 6. Auth (JWT / Passport)

Pacotes: `@nestjs/jwt`, `@nestjs/passport`, `passport-jwt`, `bcryptjs` · Docs: [Authentication](https://docs.nestjs.com/security/authentication)

| Símbolo | Quando usar | Mini exemplo | Cap. |
|---------|-------------|--------------|------|
| `JwtModule.registerAsync` | Secret + expires do `.env` | `AuthModule` | 6 |
| `PassportModule.register({ defaultStrategy: 'jwt' })` | Estratégia padrão JWT (**obrigatório** na P) | `AuthModule` — não use `PassportModule` solto | 6 |
| `PassportStrategy(Strategy)` | Extrair/validar Bearer | `JwtStrategy` | 6 |
| `ExtractJwt.fromAuthHeaderAsBearerToken()` | De onde vem o token | `jwt.strategy.ts` | 6 |
| `validate(payload)` | Vira `request.user` | `{ userId, username, role }` | 6 |
| `JwtService.signAsync` | Emitir token no login | `AuthService.login` | 6 |
| `bcrypt.hash` / `compare` (`bcryptjs`) | Senha nunca em texto puro | register / login | 6 |

Não aceite `role` no body do register (linha P).  
**401 vs 403:** ver [§3 Guards](#sec-guards).

---

<a id="sec-swagger"></a>

## 7. Swagger / OpenAPI

Pacote: `@nestjs/swagger@12` · Docs: [OpenAPI](https://docs.nestjs.com/openapi/introduction)

| Símbolo | Quando usar | Mini exemplo | Cap. |
|---------|-------------|--------------|------|
| `DocumentBuilder` / `SwaggerModule.setup` | UI em `/api` | `main.ts` | 8 |
| `@ApiTags('x')` | Agrupar no menu | `@ApiTags('products')` | 8 |
| `@ApiOperation` / `@ApiResponse` | Summary e status | documentação da rota | 8 |
| `@ApiBearerAuth()` | Cadeado + Authorize | rotas com JWT | 8–9 |
| `@ApiProperty({ example })` | Schema do DTO no Try it out | `CreateProductDto` | 8 |
| `@ApiConsumes('multipart/form-data')` | Upload no Swagger | imagem | 9 |
| `@ApiBody` (binary) | Campo `file` no form | upload | 9 |
| `PartialType` (`@nestjs/swagger`) | DTO parcial + OpenAPI | **depois** do Swagger (cap. 8); no 2.1 A use `@nestjs/mapped-types` | 2.1 **A**, 8 |

---

<a id="sec-upload"></a>

## 8. Upload (Multer)

Pacotes: `@nestjs/platform-express` (Nest 12 traz Multer 2.x), `@types/multer@2.0.0` · Docs: [File upload](https://docs.nestjs.com/techniques/file-upload)

| Símbolo | Quando usar | Mini exemplo | Cap. |
|---------|-------------|--------------|------|
| `FileInterceptor('file', opts)` | Multipart campo `file` | `POST :id/image` (+ `fileFilter` / `limits`) | 9 |
| `@UploadedFile()` | Arquivo no handler | `file: Express.Multer.File` | 9 |
| `@UseInterceptors(...)` | Plugar o interceptor | junto do `FileInterceptor` | 9 |
| `diskStorage` | Salvar em `./uploads` | `filename` com `basename` | 9 |
| `StreamableFile` | Devolver bytes no `GET` | preferir em vez de `@Res()` | 9 |

**Não** rode `npm install multer` solto nesta trilha.

---

## Mini-índice alfabético (Ctrl+F)

`401` · `403` · `@ApiBearerAuth` · `@ApiBody` · `@ApiConsumes` · `@ApiOperation` · `@ApiProperty` · `@ApiResponse` · `@ApiTags` · `@Body` · `@Column` · `@Controller` · `@CreateDateColumn` · `@Delete` · `@Entity` · `@Get` · `@HttpCode` · `@Injectable` · `@InjectRepository` · `@Is*` (ver 2.1) · `@ManyToOne` · `@Module` · `@OneToMany` · `@Param` · `@Patch` · `@Post` · `@PrimaryGeneratedColumn` · `@Put` · `@Query` · `@Req` · `@Res` · `@Roles` · `@Type` · `@UploadedFile` · `@UseGuards` · `@UseInterceptors` · `@ValidateNested` · `ConfigService` · `DataSource` · `EntityManager` · `FileInterceptor` · `JwtAuthGuard` · `JwtService` · `ParseIntPipe` · `RolesGuard` · `StreamableFile` · `ValidationPipe` · `diskStorage`

---

## Descrição de vídeo / pin (cole na descrição)

```text
Consulta rápida Nest (não é aula) · Ctrl+F no índice · pause e volte ao cap. da coluna Cap.
Arquivo: backend/nest/REFERENCIA-NEST.md · Travou? FAQ-TRAVOU.md · VERSIONS.md · CURLS-P.md
NestJS 12 + TypeORM + Postgres 16 · scaffold CJS + Jest · pins em VERSIONS.md
Shell: Bash (Linux ou Git Bash no Windows) — FAQ-TRAVOU / README
```
