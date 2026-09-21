# Análise de Vendas de E-commerce — Olist

Projeto de análise de dados de um e-commerce brasileiro, desenvolvido para identificar padrões de vendas, desempenho logístico, comportamento de pagamento e fatores relacionados à satisfação dos clientes.

## Objetivo

Transformar dados brutos de pedidos, produtos, pagamentos, entregas e avaliações em informações úteis para apoiar decisões comerciais e operacionais.

## Base de dados

Foi utilizado o conjunto **Brazilian E-Commerce Public Dataset by Olist**, composto por arquivos relacionados a:

- Pedidos
- Clientes
- Produtos
- Itens dos pedidos
- Pagamentos
- Avaliações
- Vendedores
- Localização geográfica
- Tradução das categorias de produtos

Os arquivos CSV não estão incluídos no repositório por causa do tamanho. Para executar o projeto, eles devem ser colocados na pasta `data/raw`.

## Análises realizadas

- Verificação da qualidade dos dados
- Identificação de valores ausentes e duplicados
- Análise da situação dos pedidos
- Evolução mensal do volume de pedidos
- Desempenho das entregas
- Comparação do prazo de entrega entre estados
- Análise financeira das vendas
- Categorias com maior valor vendido
- Formas de pagamento
- Parcelamento no cartão de crédito
- Distribuição das avaliações
- Relação entre atraso e satisfação dos clientes

## Principais resultados

- Foram analisados **99.441 pedidos**.
- **96.478 pedidos** foram entregues, correspondendo a uma taxa de entrega de **97,02%**.
- O pico mensal ocorreu em novembro de 2017, com **7.544 pedidos**.
- O tempo médio de entrega foi de **12,56 dias**.
- **91,89%** dos pedidos foram entregues dentro do prazo estimado.
- O valor dos produtos vendidos nos pedidos entregues foi de aproximadamente **R$ 13,22 milhões**.
- O ticket médio dos produtos foi de **R$ 137,04 por pedido**.
- O cartão de crédito concentrou **78,46% do valor pago**.
- A nota média das avaliações foi de **4,16**.
- Pedidos entregues no prazo tiveram nota média de **4,29**.
- Pedidos atrasados tiveram nota média de apenas **2,57**.
- Entre os pedidos atrasados, **54,03%** das avaliações receberam notas 1 ou 2.

## Recomendações de negócio

- Priorizar melhorias logísticas nos estados com maiores tempos de entrega.
- Monitorar pedidos enviados que permanecem sem confirmação de entrega.
- Investigar as causas de cancelamentos e indisponibilidade de produtos.
- Acompanhar as categorias de maior valor vendido para orientar decisões comerciais e de estoque.
- Utilizar o cumprimento do prazo como indicador estratégico da experiência do cliente.
- Analisar os comentários das avaliações negativas para identificar problemas recorrentes.

## Tecnologias utilizadas

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Jupyter Notebook
- Git e GitHub
- Visual Studio Code

## Estrutura do projeto

```text
analise-vendas-ecommerce/
├── data/
│   └── raw/
├── notebooks/
│   └── 01_exploracao_inicial.ipynb
├── .gitignore
├── LICENSE
├── README.md
└── requirements.txt