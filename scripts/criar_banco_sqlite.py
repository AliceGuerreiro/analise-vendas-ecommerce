from pathlib import Path
import sqlite3

import pandas as pd


RAIZ_PROJETO = Path(__file__).resolve().parents[1]
PASTA_DADOS = RAIZ_PROJETO / "data" / "raw"
PASTA_BANCO = RAIZ_PROJETO / "data" / "processed"
CAMINHO_BANCO = PASTA_BANCO / "olist.db"

ARQUIVOS_TABELAS = {
    "olist_customers_dataset.csv": "customers",
    "olist_geolocation_dataset.csv": "geolocation",
    "olist_order_items_dataset.csv": "order_items",
    "olist_order_payments_dataset.csv": "order_payments",
    "olist_order_reviews_dataset.csv": "order_reviews",
    "olist_orders_dataset.csv": "orders",
    "olist_products_dataset.csv": "products",
    "olist_sellers_dataset.csv": "sellers",
    "product_category_name_translation.csv": "category_translation",
}


def carregar_csv_no_sqlite(conexao, caminho_csv, nome_tabela):
    primeira_parte = True

    for parte in pd.read_csv(caminho_csv, chunksize=100_000):
        parte.to_sql(
            nome_tabela,
            conexao,
            if_exists="replace" if primeira_parte else "append",
            index=False,
        )
        primeira_parte = False

    total = pd.read_sql_query(
        f'SELECT COUNT(*) AS total FROM "{nome_tabela}"',
        conexao,
    ).loc[0, "total"]

    print(f"{nome_tabela}: {total:,} registros")


def criar_indices(conexao):
    indices = [
        "CREATE INDEX IF NOT EXISTS idx_orders_order_id ON orders(order_id)",
        "CREATE INDEX IF NOT EXISTS idx_customers_customer_id ON customers(customer_id)",
        "CREATE INDEX IF NOT EXISTS idx_items_order_id ON order_items(order_id)",
        "CREATE INDEX IF NOT EXISTS idx_items_product_id ON order_items(product_id)",
        "CREATE INDEX IF NOT EXISTS idx_payments_order_id ON order_payments(order_id)",
        "CREATE INDEX IF NOT EXISTS idx_reviews_order_id ON order_reviews(order_id)",
        "CREATE INDEX IF NOT EXISTS idx_products_product_id ON products(product_id)",
        "CREATE INDEX IF NOT EXISTS idx_sellers_seller_id ON sellers(seller_id)",
    ]

    for comando in indices:
        conexao.execute(comando)


def main():
    PASTA_BANCO.mkdir(parents=True, exist_ok=True)

    with sqlite3.connect(CAMINHO_BANCO) as conexao:
        for nome_arquivo, nome_tabela in ARQUIVOS_TABELAS.items():
            caminho_csv = PASTA_DADOS / nome_arquivo

            if not caminho_csv.exists():
                raise FileNotFoundError(
                    f"Arquivo não encontrado: {caminho_csv}"
                )

            carregar_csv_no_sqlite(
                conexao,
                caminho_csv,
                nome_tabela,
            )

        criar_indices(conexao)
        conexao.commit()

    print(f"\nBanco criado com sucesso em: {CAMINHO_BANCO}")


if __name__ == "__main__":
    main()