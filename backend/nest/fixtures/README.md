# Fixtures de lab

| Arquivo | Uso |
|---------|-----|
| [`caneca.jpg`](caneca.jpg) | Upload P ([cap. 9](../9.upload_arquivos.md)) — JPEG mínimo 1×1 |

No curl (a partir de `loja-api/` ou copie o arquivo):

```bash
curl ... -F "file=@../fixtures/caneca.jpg"
# ou, se copiou para loja-api/fixtures/:
# curl ... -F "file=@./fixtures/caneca.jpg"
```
