-- Show all products
SELECT * FROM products;

-- Show all orders above $100
SELECT * FROM orders WHERE price_usd > 100;

-- Find total revenue
SELECT SUM(price_usd) AS total_revenue FROM orders;

-- Find total profit
SELECT SUM(price_usd - cogs_usd) as total_profit FROM orders;

-- Find average order value
SELECT AVG(price_usd) AS average_order_value FROM orders;

-- Count total orders
SELECT COUNT(*) AS total_orders FROM orders;

-- Revenue by product
SELECT products.product_id, products.product_name, SUM(orders.price_usd) AS revenue
FROM products JOIN orders
ON products.product_id = orders.primary_product_id
GROUP BY products.product_id, products.product_name
ORDER BY revenue DESC;

-- Units sold by product
SELECT p.product_name, COUNT(oi.order_item_id) AS units_sold
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC;

-- Monthly revenue trend
SELECT 
    YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    SUM(price_usd) AS monthly_revenue
FROM orders
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY year, month;

-- Orders by device type
SELECT 
    ws.device_type,
    COUNT(o.order_id) AS total_orders
FROM website_sessions ws
JOIN orders o
ON ws.website_session_id = o.website_session_id
GROUP BY ws.device_type;

-- Sessions by traffic source
SELECT 
    utm_source,
    COUNT(*) AS total_sessions
FROM website_sessions
GROUP BY utm_source
ORDER BY total_sessions DESC;

-- Conversion rate by device type
SELECT 
    ws.device_type,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id) * 100.0 / COUNT(DISTINCT ws.website_session_id) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
ON ws.website_session_id = o.website_session_id
GROUP BY ws.device_type;

-- Conversion rate by campaign
SELECT 
    ws.utm_campaign,
    COUNT(DISTINCT ws.website_session_id) AS sessions,
    COUNT(DISTINCT o.order_id) AS orders,
    COUNT(DISTINCT o.order_id) * 100.0 / COUNT(DISTINCT ws.website_session_id) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o
ON ws.website_session_id = o.website_session_id
GROUP BY ws.utm_campaign;

-- Top landing pages
SELECT 
    pageview_url,
    COUNT(*) AS views
FROM website_pageviews
GROUP BY pageview_url
ORDER BY views DESC;

-- Total refunds
SELECT 
    SUM(refund_amount_usd) AS total_refunds
FROM order_item_refunds;

-- Refunds by product
SELECT 
    p.product_name,
    COUNT(r.order_item_refund_id) AS refund_count,
    SUM(r.refund_amount_usd) AS refund_amount
FROM order_item_refunds r
JOIN order_items oi
ON r.order_item_id = oi.order_item_id
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY refund_amount DESC;

-- Products with revenue above average order value
SELECT 
    p.product_name,
    SUM(oi.price_usd) AS revenue
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name
HAVING SUM(oi.price_usd) > (
    SELECT AVG(price_usd)
    FROM orders
);

-- New vs repeat sessions
SELECT 
    is_repeat_session,
    COUNT(*) AS total_sessions
FROM website_sessions
GROUP BY is_repeat_session;

-- Create a revenue view
CREATE VIEW product_revenue_view AS
SELECT 
    p.product_name,
    SUM(oi.price_usd) AS total_revenue,
    SUM(oi.price_usd - oi.cogs_usd) AS total_profit
FROM order_items oi
JOIN products p
ON oi.product_id = p.product_id
GROUP BY p.product_name;

SELECT *
FROM product_revenue_view;

-- Create index for optimization
CREATE INDEX idx_orders_session
ON orders(website_session_id);


