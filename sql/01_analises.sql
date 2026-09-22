-- ============================================================
-- ANÁLISE DE VENDAS DE E-COMMERCE — OLIST
-- Consultas desenvolvidas em SQLite
-- ============================================================


-- 1. Distribuição dos pedidos por situação

SELECT
    order_status AS situacao,
    COUNT(*) AS quantidade_pedidos,
    ROUND(
        100.0 * COUNT(*) / (
            SELECT COUNT(*)
            FROM orders
        ),
        2
    ) AS percentual
FROM orders
GROUP BY order_status
ORDER BY quantidade_pedidos DESC;

-- 2. Evolução mensal da quantidade de pedidos

SELECT
    strftime('%Y-%m', order_purchase_timestamp) AS mes,
    COUNT(*) AS quantidade_pedidos
FROM orders
WHERE order_purchase_timestamp >= '2016-10-01'
  AND order_purchase_timestamp < '2018-09-01'
GROUP BY mes
ORDER BY mes; 

-- 3. Indicadores de desempenho das entregas

SELECT
    COUNT(*) AS pedidos_analisados,
    ROUND(
        AVG(
            julianday(order_delivered_customer_date)
            - julianday(order_purchase_timestamp)
        ),
        2
    ) AS tempo_medio_entrega_dias,
    ROUND(
        100.0 * AVG(
            CASE
                WHEN datetime(order_delivered_customer_date)
                     <= datetime(order_estimated_delivery_date)
                THEN 1
                ELSE 0
            END
        ),
        2
    ) AS percentual_entregue_no_prazo
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

  -- 4. Evolução mensal do valor vendido

SELECT
    strftime('%Y-%m', o.order_purchase_timestamp) AS mes,
    ROUND(SUM(i.price), 2) AS gmv_produtos
FROM orders AS o
INNER JOIN order_items AS i
    ON o.order_id = i.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= '2016-10-01'
  AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY mes
ORDER BY mes;

-- 5. Dez categorias com maior valor vendido

SELECT
    COALESCE(
        t.product_category_name_english,
        p.product_category_name
    ) AS categoria,
    ROUND(SUM(i.price), 2) AS gmv_produtos,
    COUNT(*) AS quantidade_itens,
    COUNT(DISTINCT i.order_id) AS quantidade_pedidos
FROM order_items AS i
INNER JOIN orders AS o
    ON i.order_id = o.order_id
INNER JOIN products AS p
    ON i.product_id = p.product_id
LEFT JOIN category_translation AS t
    ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY categoria
ORDER BY gmv_produtos DESC
LIMIT 10;

-- 6. Participação das formas de pagamento no valor total

WITH pagamentos_entregues AS (
    SELECT
        p.order_id,
        p.payment_type,
        p.payment_value
    FROM order_payments AS p
    INNER JOIN orders AS o
        ON p.order_id = o.order_id
    WHERE o.order_status = 'delivered'
)

SELECT
    payment_type AS forma_pagamento,
    COUNT(DISTINCT order_id) AS quantidade_pedidos,
    COUNT(*) AS quantidade_transacoes,
    ROUND(SUM(payment_value), 2) AS valor_total,
    ROUND(
        100.0 * SUM(payment_value)
        / (SELECT SUM(payment_value) FROM pagamentos_entregues),
        2
    ) AS percentual_valor
FROM pagamentos_entregues
GROUP BY payment_type
ORDER BY valor_total DESC;


