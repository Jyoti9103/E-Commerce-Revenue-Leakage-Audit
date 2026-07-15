USE ecommerce_data;
SHOW TABLES;
RENAME TABLE
`part-00001-780882e4-bb00-443a-abae-a8c8c7708fcc-c000`
TO ecommerce;

-- 1. Create a clean database environment and verify rows
SELECT COUNT(*) AS Total_Records FROM ecommerce;

-- 2. Basic Data Quality Check
SELECT 
    AVG(avg_price) AS Average_Price,
    MAX(avg_price) AS Highest_Price,
    MIN(avg_price) AS Lowest_price,
    AVG(session_duration_seconds) AS Avg_Session_Duration,
    MAX(session_duration_seconds) AS Max_Session_Duration
FROM ecommerce;

-- 3. Check Conversion Performance
SELECT
    COUNT(*) AS Total_Sessions,
    SUM(label) AS Purchased,
    ROUND((SUM(label) / COUNT(*)) * 100, 2) AS Conversion_Rate
FROM ecommerce;

-- 4. THE MONEY LEAK (This is the core of your audit project)
-- Calculates how many people abandoned their carts and the estimated value of goods stuck
SELECT 
    COUNT(*) AS Cart_Abandonment_Sessions,
    ROUND(SUM(avg_price * cart_count), 2) AS Estimated_Lost_Revenue_INR
FROM ecommerce
WHERE cart_count > 0 AND label = 0;

-- 5. User Behavior Analysis (Split by those who bought vs those who didn't)
SELECT
    label,
    COUNT(*) AS Session_Count,
    ROUND(AVG(session_duration_seconds), 2) AS Avg_Duration,
    ROUND(AVG(view_count), 2) AS Avg_Views,
    ROUND(AVG(cart_count), 2) AS Avg_Cart
FROM ecommerce
GROUP BY label;

-- 6. Funnel Stage Overview
SELECT
    COUNT(*) AS Total_Sessions,
    SUM(CASE WHEN view_count > 0 THEN 1 ELSE 0 END) AS Total_Viewed,
    SUM(CASE WHEN cart_count > 0 THEN 1 ELSE 0 END) AS Total_Carted,
    SUM(CASE WHEN label = 1 THEN 1 ELSE 0 END) AS Total_Purchased
FROM ecommerce;