/*Criação das Tabelas:*/

CREATE TABLE Cardapio (
  id              SERIAL PRIMARY KEY,              
  nome            VARCHAR(100) NOT NULL UNIQUE,
  descricao       VARCHAR(255) NOT NULL,
  preco_unitario  DECIMAL(10,2) NOT NULL CHECK (preco_unitario > 0)
);

-- COMANDA
CREATE TABLE Comanda (
  id       SERIAL PRIMARY KEY,                     
  "data"   DATE NOT NULL,                          
  mesa     INT NOT NULL CHECK (mesa > 0),
  cliente  VARCHAR(120) NOT NULL
);

-- ITENS DA COMANDA
CREATE TABLE ItensComanda (
  comanda_id   INT NOT NULL,
  cardapio_id  INT NOT NULL,
  quantidade   INT NOT NULL CHECK (quantidade > 0),

  CONSTRAINT pk_itens PRIMARY KEY (comanda_id, cardapio_id), 
  CONSTRAINT fk_itens_comanda  FOREIGN KEY (comanda_id)  REFERENCES Comanda(id)  ON DELETE CASCADE,
  CONSTRAINT fk_itens_cardapio FOREIGN KEY (cardapio_id) REFERENCES Cardapio(id) ON DELETE RESTRICT
);

-- Índices úteis (opcional, melhora performance das consultas)
CREATE INDEX idx_itens_comanda  ON ItensComanda (comanda_id);
CREATE INDEX idx_itens_cardapio ON ItensComanda (cardapio_id);
CREATE INDEX idx_comanda_data   ON Comanda ("data");

--------------------------------------------------------------------------
/*Populando as tabelas*/

-- CARDÁPIO
INSERT INTO Cardapio (nome, descricao, preco_unitario) VALUES
  ('Espresso',               'Café curto, extraído sob pressão',                  6.50),
  ('Americano',              'Espresso diluído em água quente',                   7.50),
  ('Cappuccino',             'Espresso, leite vaporizado e espuma de leite',      9.90),
  ('Latte',                  'Espresso com bastante leite vaporizado',            9.50),
  ('Mocha',                  'Espresso, chocolate e leite vaporizado',           10.90),
  ('Macchiato',              'Espresso marcado com um toque de leite',            7.90),
  ('Café com Leite',         'Café filtrado com leite quente',                     6.90),
  ('Cold Brew',              'Café extraído a frio por longas horas',            11.50),
  ('Affogato',               'Espresso sobre sorvete de creme',                  12.90),
  ('Flat White',             'Espresso com microespuma de leite, cremoso',       10.50);

-- COMANDAS
INSERT INTO Comanda ("data", mesa, cliente) VALUES
  ('2025-10-20', 1, 'Paula Dantas'),
  ('2025-10-20', 2, 'João Silva'),
  ('2025-10-21', 3, 'Maria Oliveira'),
  ('2025-10-21', 1, 'Bruno Costa'),
  ('2025-10-22', 4, 'Ana Souza'),
  ('2025-10-22', 2, 'Carla Mendes');

-- ITENS 
-- Comanda 1 (2 tipos de café)
INSERT INTO ItensComanda (comanda_id, cardapio_id, quantidade) VALUES
  (1, (SELECT id FROM Cardapio WHERE nome='Espresso'), 2),
  (1, (SELECT id FROM Cardapio WHERE nome='Cappuccino'), 1);

-- Comanda 2 (1 tipo)
INSERT INTO ItensComanda (comanda_id, cardapio_id, quantidade) VALUES
  (2, (SELECT id FROM Cardapio WHERE nome='Latte'), 2);

-- Comanda 3 (3 tipos)
INSERT INTO ItensComanda (comanda_id, cardapio_id, quantidade) VALUES
  (3, (SELECT id FROM Cardapio WHERE nome='Americano'), 1),
  (3, (SELECT id FROM Cardapio WHERE nome='Mocha'), 1),
  (3, (SELECT id FROM Cardapio WHERE nome='Affogato'), 1);

-- Comanda 4 (1 tipo)
INSERT INTO ItensComanda (comanda_id, cardapio_id, quantidade) VALUES
  (4, (SELECT id FROM Cardapio WHERE nome='Cold Brew'), 1);

-- Comanda 5 (2 tipos)
INSERT INTO ItensComanda (comanda_id, cardapio_id, quantidade) VALUES
  (5, (SELECT id FROM Cardapio WHERE nome='Flat White'), 2),
  (5, (SELECT id FROM Cardapio WHERE nome='Macchiato'), 1);

-- Comanda 6 (2 tipos)
INSERT INTO ItensComanda (comanda_id, cardapio_id, quantidade) VALUES
  (6, (SELECT id FROM Cardapio WHERE nome='Café com Leite'), 3),
  (6, (SELECT id FROM Cardapio WHERE nome='Espresso'), 1);

----------------------------------------------------------------
--CONSULTAS

/*1) Faça uma listagem do cardápio ordenada por nome;*/

SELECT
  id        AS codigo,
  nome,
  descricao,
  preco_unitario
FROM Cardapio
ORDER BY nome;

/*2) Apresente todas as comandas (código, data, mesa e nome do cliente) e os itens 
da comanda (código comanda, nome do café, descricão, quantidade, preço unitário e preço 
total do café) destas ordenados data e código da comanda e, também o nome do café;*/


SELECT
  c.id                       AS codigo_comanda,
  c.data,
  c.mesa,
  c.cliente,
  ca.nome                    AS nome_cafe,
  ca.descricao,
  i.quantidade,
  ca.preco_unitario,
  i.quantidade * ca.preco_unitario AS preco_total_item
FROM Comanda c
JOIN ItensComanda i   ON i.comanda_id  = c.id
JOIN Cardapio    ca   ON ca.id          = i.cardapio_id
ORDER BY c.data, c.id, ca.nome;

/* 3) Liste todas as comandas (código, data, mesa e nome do cliente) mais uma coluna com 
o valor total da comanda. Ordene por data esta listagem;*/

SELECT
  c.id      AS codigo_comanda,
  c.data,
  c.mesa,
  c.cliente,
  SUM(i.quantidade * ca.preco_unitario) AS valor_total_comanda
FROM Comanda c
JOIN ItensComanda i ON i.comanda_id = c.id
JOIN Cardapio ca    ON ca.id        = i.cardapio_id
GROUP BY c.id, c.data, c.mesa, c.cliente
ORDER BY c.data;

/*4) Faça a mesma listagem das comandas da questão anterior (6), mas traga apenas as 
comandas que possuem mais do que um tipo de café na comanda;*/

SELECT
  c.id      AS codigo_comanda,
  c.data,
  c.mesa,
  c.cliente,
  SUM(i.quantidade * ca.preco_unitario) AS valor_total_comanda
FROM Comanda c
JOIN ItensComanda i ON i.comanda_id = c.id
JOIN Cardapio ca    ON ca.id        = i.cardapio_id
GROUP BY c.id, c.data, c.mesa, c.cliente
HAVING COUNT(DISTINCT i.cardapio_id) > 1
ORDER BY c.data;

/*5) Qual o total de faturamento por data? ordene por data esta consulta.*/

SELECT
  c.data,
  SUM(i.quantidade * ca.preco_unitario) AS faturamento_dia
FROM Comanda c
JOIN ItensComanda i ON i.comanda_id = c.id
JOIN Cardapio ca    ON ca.id        = i.cardapio_id
GROUP BY c.data
ORDER BY c.data;