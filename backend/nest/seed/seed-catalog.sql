-- Seed parcial: só catálogo (após cap. 5 — tabela products).
-- Use seed.sql completo depois de auth (users) + pedidos (orders).
--
-- DELETE + ALTER SEQUENCE (mesma política do seed.sql).
-- Só use no cap. 5 (antes de pedidos). Depois do 5.1, prefira seed.sql:
-- reaplicar só este arquivo apaga products e reinicia a sequence, mas
-- NÃO limpa order_items — pedidos antigos ficam apontando para ids reciclados.

DELETE FROM products;

ALTER SEQUENCE products_id_seq RESTART WITH 1;

INSERT INTO products (name, price, stock) VALUES
  ('Caneca Nest', 39.90, 10),
  ('Camiseta ADS', 59.90, 25);

SELECT id, name, price, stock FROM products ORDER BY id;
