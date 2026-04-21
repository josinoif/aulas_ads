# Entrega Avaliativa do Módulo 7

**Módulo:** Kubernetes (6h)
**Cenário:** StreamCast EDU — ver [00-cenario-pbl.md](00-cenario-pbl.md)

---

## Objetivo da entrega

Construir o **MVP da StreamCast EDU no Kubernetes**: um cluster local (k3d) rodando **2 ou 3 serviços** da plataforma, empacotados como **Helm chart**, sincronizados via **ArgoCD**, com probes, resource limits, HPA, Ingress, NetworkPolicy, RBAC mínimo, secrets gerenciados e um plano de migração dos demais serviços.

---

## O que entregar

### 1. Repositório GitHub com:

Estrutura sugerida:

```
streamcast-k8s/
├── README.md
├── Makefile
├── app/                           # aplicação(s) em Python
│   ├── auth/
│   │   ├── src/
│   │   ├── pyproject.toml
│   │   ├── Dockerfile
│   │   └── tests/
│   └── ...
├── k8s/                           # manifestos crus (para aprendizado)
│   ├── namespace.yaml
│   ├── rbac.yaml
│   └── ...
├── charts/                        # Helm charts
│   └── streamcast/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── values-dev.yaml
│       ├── values-stg.yaml
│       └── templates/
├── argocd/
│   ├── apps/
│   │   ├── streamcast-dev.yaml
│   │   └── streamcast-stg.yaml
│   └── install/
├── scripts/
│   ├── k3d-up.sh
│   ├── k3d-down.sh
│   ├── k8s_audit.py
│   └── explore_cluster.py
├── docs/
│   ├── arquitetura.md
│   ├── adr/
│   ├── runbook-onboarding-tenant.md
│   ├── plano-migracao.md
│   └── limites-reconhecidos.md
└── .github/workflows/
    └── ci.yml
```

### 2. Cluster local reproduzível

- Script `k3d-up.sh` cria um cluster com **3 nós** (1 server + 2 agents) em < 1 min.
- Documentação clara do `Makefile`: `make up`, `make deploy`, `make clean`.

### 3. Ao menos **2 serviços da StreamCast** implantados

Escolha de seu portfólio:

- **Obrigatório:** 1 serviço **stateless** (ex.: `auth`, `catalog`, `api-gateway`) com API HTTP real.
- **Obrigatório:** 1 serviço com **dependência externa** (Postgres ou Redis) com `PersistentVolumeClaim`.
- **Opcional:** 1 serviço **batch/job** (ex.: `transcoder` simulado).

Cada serviço deve ter:

- `Deployment` com `readinessProbe` e `livenessProbe` **funcionais**.
- `Service` (ClusterIP).
- `ConfigMap` para config não sensível.
- `Secret` para credenciais (sem hardcoded).
- Resource **requests e limits** definidos e justificados.
- `Ingress` para o ponto de entrada.

### 4. Operações de produção

- **Namespaces**: `streamcast-dev`, `streamcast-stg` (mínimo). Idealmente por tenant: `tenant-ufpb-dev`, etc.
- **RBAC**: `ServiceAccount` dedicada por serviço; papéis mínimos necessários; **não** usar `default`.
- **NetworkPolicy**: `deny all` por padrão + regras explícitas de egresso/ingresso. Demonstre que bloqueia tráfego proibido.
- **HPA**: em ao menos 1 serviço, escalando por CPU ou métrica custom.
- **PodDisruptionBudget**: em ao menos 1 serviço crítico.

### 5. Helm chart

- Chart único em `charts/streamcast/` parametrizando **todos** os serviços.
- `values.yaml` com defaults; `values-dev.yaml` e `values-stg.yaml` com overrides por ambiente.
- Templates idiomáticos (helpers `_helpers.tpl` para labels, nome, chart).
- `helm lint` passa.
- Testes com `helm template` mostrando a saída.

### 6. GitOps com ArgoCD

- ArgoCD instalado **no próprio cluster** via Helm ou manifest.
- ≥ 2 `Application` do ArgoCD apontando para seu repo (dev e stg).
- Sync automático em `main`.
- Evidência: print do ArgoCD UI com 2 apps **Healthy + Synced**.

### 7. Scripts Python de apoio

- `scripts/k8s_audit.py`: audita o cluster — conta pods, checa probes, limits, uso de `default` namespace, image tags `latest`, etc.
- `scripts/explore_cluster.py`: lista objetos principais com rich output.

### 8. CI básica

`.github/workflows/ci.yml` rodando em PR:

- Lint de manifestos (`kubeval` ou `kubeconform`).
- `helm lint` + `helm template`.
- `k8s_audit.py` contra um cluster kind/k3d efêmero subido em CI **ou** dry-run de templates.
- Build + push de imagem (reusa do Módulo 5).

### 9. Runbook de onboarding de novo tenant

`docs/runbook-onboarding-tenant.md`:

1. Criar PR adicionando `values-tenant-<nome>.yaml`.
2. PR passa lint + render.
3. Merge → ArgoCD detecta → aplica → namespace criado → pods sobem.
4. Output esperado: URL e credenciais por canal seguro.
5. Meta: **≤ 1 hora** ponta-a-ponta.

### 10. ADRs (≥ 3)

- **ADR 001 — Distribuição K8s local** (k3d vs kind vs minikube).
- **ADR 002 — Helm vs Kustomize** (escolha + justificativa).
- **ADR 003 — GitOps (ArgoCD vs Flux)**.
- **Opcionais:** ADR 004 — estratégia de namespaces por tenant; ADR 005 — secrets.

### 11. Plano de migração dos demais serviços

`docs/plano-migracao.md`: ondas realistas migrando os 8 serviços, com critérios, riscos, ordem.

### 12. Limites reconhecidos

`docs/limites-reconhecidos.md`:

- K8s não resolve: bugs de aplicação, backup/restore de dados, custo operacional, observabilidade (Módulo 8), segurança em profundidade (Módulo 9).
- O que falta para ir à produção real (etcd em HA, ingress TLS com cert-manager, backup `velero`, monitoramento).

### 13. Evidências

No README:

- Link do workflow de CI verde.
- Print do ArgoCD UI com apps Healthy.
- Print de `kubectl get all -n streamcast-dev` mostrando tudo Running.
- Print de HPA escalando sob carga (pode simular com `kubectl run -it --rm load-gen -- /bin/sh`).
- Resultado do `k8s_audit.py`.
- Tempo medido de onboarding de novo tenant (seu runbook).

---

## Critérios de avaliação

| Critério | Peso | O que se espera |
|----------|------|------------------|
| **Cluster local reproduzível** | 5% | `make up` funciona do zero |
| **Manifestos corretos (2 serviços)** | 20% | Deployment, Service, ConfigMap, Secret, probes, limits |
| **Operações (RBAC, NetPol, HPA, PDB)** | 20% | Configurações realistas, NetworkPolicy comprovada |
| **Helm chart idiomático** | 15% | `helm lint` passa, values por ambiente, helpers |
| **GitOps funcionando (ArgoCD)** | 15% | 2 apps Healthy + Synced |
| **CI + scripts de audit** | 10% | Pipeline verde; `k8s_audit.py` roda e aponta issues reais |
| **Runbook + tempo medido** | 5% | Runbook executado por terceiro em ≤ 1h |
| **ADRs + plano + limites** | 10% | Decisões defensáveis, plano realista, limites honestos |

---

## Formato e prazo

- **Formato:** link do repositório GitHub.
- **Prazo:** conforme definido pelo professor. Sugestão: **1,5 semanas** após encerramento do módulo.
- **Avaliação:** o professor pode clonar e executar `make up && make deploy` e esperar ver tudo rodar.

---

## Dicas

- **Comece pequeno.** Faça 1 serviço rodar end-to-end antes de trazer o segundo. Cluster → Deployment → Service → Ingress → ArgoCD. Só então Helm.
- **Leia `kubectl describe` sempre** que algo falhar. É onde o cluster te explica o porquê.
- **Use `k9s`** para desenvolvimento — acelera muito.
- **Não crie infinitos namespaces** para o MVP. Comece com 2. Depois, se tiver tempo e energia, experimente 1 por tenant.
- **`Secret` nativo do K8s é `base64`, não criptografia**. Mencione isso em `limites-reconhecidos.md` e sinalize que em produção real haveria **sealed-secrets** ou **External Secrets** (Módulo 9).

---

## Referência rápida do módulo

- [Cenário PBL — StreamCast EDU](00-cenario-pbl.md)
- [Bloco 1 — Fundamentos de Kubernetes](bloco-1/01-fundamentos-k8s.md)
- [Bloco 2 — Workloads](bloco-2/02-workloads.md)
- [Bloco 3 — Operações](bloco-3/03-operacoes-cluster.md)
- [Bloco 4 — Produção, Helm, GitOps](bloco-4/04-producao-helm-gitops.md)
- [Exercícios progressivos](exercicios-progressivos/)
- [Referências bibliográficas](referencias.md)
