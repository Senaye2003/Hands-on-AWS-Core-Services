-- ============================================================
-- ITCS 6190/8190 - Hands-on: AWS Core Services (S3, Glue, CloudWatch, Athena)
-- Dataset: Amazon Sale Report (E-Commerce Sales Data)
-- Database: itcs6190_db_sweldebe   Table: raw_data
-- Note: "date" is quoted because it is a reserved keyword in Athena.
--       Cancelled/Pending orders are excluded with NOT LIKE to catch
--       all variants (e.g. "Pending - Waiting for Pick Up").
-- ============================================================


-- Query 1 - Basic Table Exploration
-- Retrieve the first 10 records.
SELECT *
FROM raw_data
LIMIT 10;


-- Query 2 - Orders by Product Category
-- Count of each product category and the total number of orders in it.
SELECT category,
       COUNT(*) AS total_orders
FROM raw_data
GROUP BY category
ORDER BY total_orders DESC
LIMIT 10;


-- Query 3 - Revenue and Quantity by Fulfilment Method
-- Each fulfilment method with total orders, total units sold, and total
-- revenue, excluding cancelled and pending orders, highest revenue first.
SELECT fulfilment,
       COUNT(*)              AS total_orders,
       SUM(qty)              AS total_units_sold,
       ROUND(SUM(amount), 2) AS total_revenue
FROM raw_data
WHERE status NOT LIKE '%Cancelled%'
  AND status NOT LIKE '%Pending%'
GROUP BY fulfilment
ORDER BY total_revenue DESC
LIMIT 10;


-- Query 4 - Monthly Sales Trend
-- Each month with total orders and total revenue, excluding cancelled and
-- pending orders, sorted chronologically (earliest to latest).
SELECT date_format(date_parse("date", '%m-%d-%y'), '%Y-%m') AS month,
       COUNT(*)              AS total_orders,
       ROUND(SUM(amount), 2) AS total_revenue
FROM raw_data
WHERE status NOT LIKE '%Cancelled%'
  AND status NOT LIKE '%Pending%'
GROUP BY date_format(date_parse("date", '%m-%d-%y'), '%Y-%m')
ORDER BY month ASC
LIMIT 10;


-- Query 5 - Top 5 Best-Selling SKUs per Category
-- Top 5 SKUs in each category ranked by total revenue, showing category,
-- SKU, total revenue, total units sold, and rank. Excludes cancelled,
-- pending, and zero-quantity orders.
WITH ranked AS (
    SELECT category,
           sku,
           ROUND(SUM(amount), 2) AS total_revenue,
           SUM(qty)              AS total_units_sold,
           RANK() OVER (PARTITION BY category ORDER BY SUM(amount) DESC) AS rank
    FROM raw_data
    WHERE status NOT LIKE '%Cancelled%'
      AND status NOT LIKE '%Pending%'
      AND qty > 0
    GROUP BY category, sku
)
SELECT category,
       sku,
       total_revenue,
       total_units_sold,
       rank
FROM ranked
WHERE rank <= 5
ORDER BY category, rank
LIMIT 10;
