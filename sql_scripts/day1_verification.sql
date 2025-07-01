
-- Check all tables created
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;

-- Verify customer data
SELECT 
    company_name,
    contact_name,
    city,
    country
FROM customers
LIMIT 10;

-- Quick data overview
SELECT 
    'Customers' as table_name,
    COUNT(*) as record_count
FROM customers
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL  
SELECT 'Products', COUNT(*) FROM products;
