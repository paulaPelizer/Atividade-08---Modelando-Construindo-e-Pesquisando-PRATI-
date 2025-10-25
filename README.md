☕ Cafeteria BomGosto – Sistema de Controle de Vendas

Banco de dados relacional desenvolvido para gerenciar vendas de café por meio de comandas.
O projeto inclui criação das tabelas, inserção de dados e consultas SQL principais.

🧱 Estrutura do Banco
Tabela	Descrição
Cardapio	Armazena cafés disponíveis, com nome, descrição e preço unitário.
Comanda	Registra cada venda: data, mesa e cliente.
ItensComanda	Relaciona cafés vendidos em cada comanda (quantidade e valor).
⚙️ Funcionalidades

✅ Criação das tabelas com chaves primárias e estrangeiras.
✅ População inicial com cafés e comandas de exemplo.
✅ Consultas SQL para:

Listar o cardápio em ordem alfabética;

Exibir comandas e itens com valores totais;

Calcular o valor total por comanda;

Filtrar comandas com mais de um tipo de café;

Calcular o faturamento diário.
