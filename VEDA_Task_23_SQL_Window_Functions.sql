-- VEDA TECHNOLOGY - TASK 23
-- SQL Window Functions Intro

DROP DATABASE IF EXISTS veda_task23;
CREATE DATABASE veda_task23;
USE veda_task23;

-- Create sales table
CREATE TABLE sales (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    product VARCHAR(50),
    category VARCHAR(30),
    amount DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO sales VALUES
(1, 101, '2026-01-05', 'Laptop', 'Technology', 50000),
(2, 102, '2026-01-08', 'Phone', 'Technology', 30000),
(3, 103, '2026-01-10', 'Chair', 'Furniture', 8000),
(4, 101, '2026-01-15', 'Monitor', 'Technology', 15000),
(5, 104, '2026-01-18', 'Table', 'Furniture', 12000),
(6, 105, '2026-01-20', 'Printer', 'Technology', 18000),
(7, 102, '2026-01-22', 'Keyboard', 'Technology', 5000),
(8, 103, '2026-01-25', 'Desk', 'Furniture', 20000),
(9, 104, '2026-01-27', 'Mouse', 'Technology', 3000),
(10, 105, '2026-01-28', 'Chair', 'Furniture', 9000),
(11, 101, '2026-02-01', 'Headphones', 'Technology', 7000),
(12, 102, '2026-02-03', 'Desk', 'Furniture', 22000);


-- QUERY 1: Display all sales
SELECT * 
FROM sales;


-- QUERY 2: ROW_NUMBER by amount
SELECT
    order_id,
    customer_id,
    product,
    amount,
    ROW_NUMBER() OVER (ORDER BY amount DESC) AS row_num
FROM sales;


-- QUERY 3: ROW_NUMBER within each category
SELECT
    order_id,
    product,
    category,
    amount,
    ROW_NUMBER() OVER (
        PARTITION BY category
        ORDER BY amount DESC
    ) AS category_row_num
FROM sales;


-- QUERY 4: RANK by amount
SELECT
    order_id,
    product,
    amount,
    RANK() OVER (ORDER BY amount DESC) AS sales_rank
FROM sales;


-- QUERY 5: RANK within category
SELECT
    order_id,
    product,
    category,
    amount,
    RANK() OVER (
        PARTITION BY category
        ORDER BY amount DESC
    ) AS category_rank
FROM sales;
SELECT
    order_id,
    product,
    category,
    amount,
    DENSE_RANK() OVER (
        ORDER BY amount DESC
    ) AS amount_rank
FROM sales;


-- QUERY 7: DENSE_RANK within category
SELECT
    order_id,
    product,
    category,
    amount,
    DENSE_RANK() OVER (
        PARTITION BY category
        ORDER BY amount DESC
    ) AS category_dense_rank
FROM sales;


-- QUERY 8: LAG previous sale amount
SELECT
    order_id,
    customer_id,
    product,
    amount,
    LAG(amount) OVER (
        ORDER BY order_date
    ) AS previous_amount
FROM sales;


-- QUERY 9: Compare current amount with previous amount
SELECT
    order_id,
    product,
    amount,
    LAG(amount) OVER (
        ORDER BY order_date
    ) AS previous_amount,
    amount - LAG(amount) OVER (
        ORDER BY order_date
    ) AS amount_difference
FROM sales;


-- QUERY 10: Previous order amount for each customer
SELECT
    order_id,
    customer_id,
    product,
    amount,
    LAG(amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS previous_customer_amount
FROM sales;


-- QUERY 11: Rank customers based on total sales
SELECT
    customer_id,
    SUM(amount) AS total_sales,
    RANK() OVER (
        ORDER BY SUM(amount) DESC
    ) AS customer_rank
FROM sales
GROUP BY customer_id;


-- QUERY 12: Top product in each category
SELECT *
FROM (
    SELECT
        order_id,
        product,
        category,
        amount,
        ROW_NUMBER() OVER (
            PARTITION BY category
            ORDER BY amount DESC
        ) AS rn
    FROM sales
) AS ranked_sales
WHERE rn = 1;
SELECT
    order_id,
    customer_id,
    product,
    amount,
    LAG(amount) OVER (
        ORDER BY order_date
    ) AS previous_amount
FROM sales;
SELECT
    order_id,
    customer_id,
    product,
    amount,
    LAG(amount) OVER (
        ORDER BY order_date
    ) AS previous_amount
FROM sales;
SELECT
    order_id,
    customer_id,
    product,
    amount,
    LAG(amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS previous_customer_amount
FROM sales;
SELECT
    order_id,
    product,
    amount,
    LAG(amount) OVER (
        ORDER BY order_date
    ) AS previous_amount,
    amount - LAG(amount) OVER (
        ORDER BY order_date
    ) AS amount_difference
FROM sales;