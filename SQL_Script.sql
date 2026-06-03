CREATE DATABASE maven_fuzzy_store;

USE maven_fuzzy_store;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    created_at DATETIME,
    product_name VARCHAR(255)
);

SET GLOBAL local_infile = 1;
SET FOREIGN_KEY_CHECKS = 0;

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

CREATE TABLE website_sessions (
    website_session_id INT PRIMARY KEY,
    created_at DATETIME,
    user_id INT,
    is_repeat_session TINYINT,
    utm_source VARCHAR(100),
    utm_campaign VARCHAR(100),
    utm_content VARCHAR(100),
    device_type VARCHAR(50),
    http_referer VARCHAR(255)
);

LOAD DATA LOCAL INFILE 'C:\\Users\\Abhishek\\Desktop\\Elevate Labs Data Analytics Internship\\Task 3\\website_sessions.csv'
INTO TABLE website_sessions
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE website_pageviews (
    website_pageview_id INT PRIMARY KEY,
    created_at DATETIME,
    website_session_id INT,
    pageview_url VARCHAR(255),
    FOREIGN KEY (website_session_id) 
        REFERENCES website_sessions(website_session_id)
);

LOAD DATA LOCAL INFILE 'C:\\Users\\Abhishek\\Desktop\\Elevate Labs Data Analytics Internship\\Task 3\\website_pageviews.csv'
INTO TABLE website_pageviews
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    created_at DATETIME,
    website_session_id INT,
    user_id INT,
    primary_product_id INT,
    items_purchased INT,
    price_usd DECIMAL(10,2),
    cogs_usd DECIMAL(10,2),
    FOREIGN KEY (website_session_id) 
        REFERENCES website_sessions(website_session_id),
    FOREIGN KEY (primary_product_id) 
        REFERENCES products(product_id)
);

LOAD DATA LOCAL INFILE 'C:\\Users\\Abhishek\\Desktop\\Elevate Labs Data Analytics Internship\\Task 3\\orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    created_at DATETIME,
    order_id INT,
    product_id INT,
    is_primary_item TINYINT,
    price_usd DECIMAL(10,2),
    cogs_usd DECIMAL(10,2),
    FOREIGN KEY (order_id) 
        REFERENCES orders(order_id),
    FOREIGN KEY (product_id) 
        REFERENCES products(product_id)
);

LOAD DATA LOCAL INFILE 'C:\\Users\\Abhishek\\Desktop\\Elevate Labs Data Analytics Internship\\Task 3\\order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE order_item_refunds (
    order_item_refund_id INT PRIMARY KEY,
    created_at DATETIME,
    order_item_id INT,
    order_id INT,
    refund_amount_usd DECIMAL(10,2),
    FOREIGN KEY (order_item_id) 
        REFERENCES order_items(order_item_id),
    FOREIGN KEY (order_id) 
        REFERENCES orders(order_id)
);

LOAD DATA LOCAL INFILE 'C:\\Users\\Abhishek\\Desktop\\Elevate Labs Data Analytics Internship\\Task 3\\order_item_refunds.csv'
INTO TABLE order_item_refunds
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT 'products' AS table_name, COUNT(*) FROM products
UNION ALL
SELECT 'website_sessions', COUNT(*) FROM website_sessions
UNION ALL
SELECT 'website_pageviews', COUNT(*) FROM website_pageviews
UNION ALL

SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'order_item_refunds', COUNT(*) FROM order_item_refunds;

SET FOREIGN_KEY_CHECKS = 1;
