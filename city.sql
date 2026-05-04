WITH customer_orders AS (
  SELECT 
    customers.customer_id,
    customer_city AS city, customer_state AS state,
    orders.order_id
  FROM `sql-portfolio-494701.olist.customers` AS customers
  LEFT JOIN `sql-portfolio-494701.olist.orders` AS orders
    ON customers.customer_id = orders.customer_id),

    joined_data AS (
      SELECT city, state, order_items.price, order_items.freight_value
      FROM customer_orders
      LEFT JOIN `sql-portfolio-494701.olist.order_items` AS order_items
      ON customer_orders.order_id = order_items.order_id),

    city_totals AS (SELECT  DISTINCT city, state,
    ROUND(SUM(price) OVER (PARTITION BY city),2) AS total_price,
    ROUND(SUM(freight_value) OVER (PARTITION BY city),2) AS total_freight
  FROM joined_data)

  SELECT *,
  RANK() OVER (ORDER BY total_price DESC) AS rank_by_sales,
  ROUND(total_price / SUM(total_price) OVER () * 100,2) AS percentage_of_total

FROM city_totals;
