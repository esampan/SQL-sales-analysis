WITH orders_products AS (
    SELECT order_items.product_id, price, freight_value, products.product_category_name
    FROM `sql-portfolio-494701.olist.order_items` AS order_items
    LEFT JOIN `sql-portfolio-494701.olist.products` AS products
    ON order_items.product_id = products.product_id),

    category_price AS (SELECT category_english.string_field_1 AS category, 
        ROUND(SUM(price),2) AS total_price, 
        ROUND(SUM(freight_value),2) AS total_freight
  FROM orders_products AS op
  LEFT JOIN `sql-portfolio-494701.olist.product_category_translate` AS category_english
  ON op.product_category_name = category_english.string_field_0
  GROUP BY category_english.string_field_1
  ORDER BY total_price DESC)

SELECT *,
ROUND (total_price / SUM(total_price) OVER () * 100,2) AS percentage_of_total
FROM category_price
WHERE category IS NOT NULL
LIMIT 10;
