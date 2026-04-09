--1. Total Overview.
SELECT 
    COUNT(DISTINCT invoiceno) AS total_transactions,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customerid) AS total_customers,
    COUNT(DISTINCT description) AS total_products,
    ROUND(SUM(quantity * unitprice)::numeric, 2) AS "Total Revenue",
    ROUND(AVG(quantity * unitprice)::numeric, 2) AS "Avg Order Value"
FROM retail_data;

-- 2. Top 10 Best Selling Products.
SELECT 
    description,
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_quantity
FROM retail_data
GROUP BY description
ORDER BY total_orders DESC
LIMIT 10;

-- 3. Monthly Revenue.
SELECT 
    TO_CHAR(invoicedate::timestamp, 'YYYY-MM') AS month,
    ROUND(SUM(quantity * unitprice)::numeric, 2) AS total_revenue,
    SUM(quantity) AS total_quantity
FROM retail_data
GROUP BY month
ORDER BY month;

-- 4. Monthly Sales Trend.
SELECT 
    TO_CHAR(invoicedate::timestamp, 'YYYY-MM') AS month,
    COUNT(DISTINCT invoiceno) AS total_invoices,
    SUM(quantity) AS total_quantity
FROM retail_data
GROUP BY month
ORDER BY month;

-- 5. Top 10 Customers by Revenue.
SELECT 
    customerid,
    COUNT(DISTINCT invoiceno) AS total_orders,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(quantity * unitprice)::numeric, 2) AS total_revenue
FROM retail_data
GROUP BY customerid
ORDER BY total_revenue DESC
LIMIT 10;

-- 6. Average Order Value.
SELECT 
    ROUND(AVG(order_value)::numeric, 2) AS avg_order_value,
    ROUND(MAX(order_value)::numeric, 2) AS max_order_value,
    ROUND(MIN(order_value)::numeric, 2) AS min_order_value
FROM (
    SELECT 
        invoiceno,
        SUM(quantity * unitprice) AS order_value
    FROM retail_data
    GROUP BY invoiceno
) AS order_summary;

-- 7. Most Expensive Products.
SELECT 
    description,
    ROUND(MAX(unitprice)::numeric, 2) AS max_price,
    ROUND(AVG(unitprice)::numeric, 2) AS avg_price,
    SUM(quantity) AS total_sold
FROM retail_data
GROUP BY description
ORDER BY max_price DESC
LIMIT 10;

-- 8. Peak Sales Hour.
SELECT 
    EXTRACT(HOUR FROM invoicedate::timestamp) AS hour,
    COUNT(DISTINCT invoiceno) AS total_orders,
    SUM(quantity) AS total_quantity
FROM retail_data
GROUP BY hour
ORDER BY total_orders DESC;

-- 9. TOP 10 ASSOCIATION RULES BY LIFT.
SELECT
    ROW_NUMBER() OVER (ORDER BY lift DESC) AS "Rank",
    antecedents AS "If Customer Buys",
    consequents AS "They Also Buy",
    ROUND(support::numeric, 4) AS "Support",
    ROUND(confidence::numeric, 4) AS "Confidence",
    ROUND(lift::numeric, 4) AS "Lift"
FROM association_rules
ORDER BY lift DESC
LIMIT 10;

-- 10. Top 10 Frequent Itemsets.
SELECT
    ROW_NUMBER() OVER (ORDER BY support DESC) AS "Rank",
    itemsets AS "Product",
    ROUND(support::numeric, 4) AS "Support"
FROM frequent_items
ORDER BY support DESC
LIMIT 10;