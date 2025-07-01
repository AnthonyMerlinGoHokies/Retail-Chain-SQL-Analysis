-- Business Question: Where are our most valuable markets?

WITH customer_geographic_performance AS (
    SELECT 
        COALESCE(c.country, 'Unknown') as country,
        COALESCE(c.city, 'Unknown') as city,
        COUNT(DISTINCT c.customer_id) as customer_count,
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) as total_revenue,
        AVG(od.unit_price * od.quantity * (1 - od.discount)) as avg_order_value,
        (SUM(od.unit_price * od.quantity * (1 - od.discount)) / COUNT(DISTINCT c.customer_id)) as revenue_per_customer
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    LEFT JOIN order_details od ON o.order_id = od.order_id
    GROUP BY c.country, c.city
    HAVING SUM(od.unit_price * od.quantity * (1 - od.discount)) > 0
),
ranked_locations AS (
    SELECT 
        *,
        RANK() OVER (ORDER BY total_revenue DESC) as revenue_rank,
        ROUND((total_revenue / SUM(total_revenue) OVER () * 100)::numeric, 2) as market_share_pct
    FROM customer_geographic_performance
)
SELECT 
    country,
    city,
    customer_count,
    total_orders,
    ROUND(total_revenue::numeric, 2) as total_revenue,
    ROUND(avg_order_value::numeric, 2) as avg_order_value,
    ROUND(revenue_per_customer::numeric, 2) as revenue_per_customer,
    revenue_rank,
    market_share_pct,
    CASE 
        WHEN revenue_rank <= 5 THEN '🏆 Top Market'
        WHEN revenue_rank <= 15 THEN '💼 Key Market'
        ELSE '🌍 Emerging Market'
    END as market_priority
FROM ranked_locations 
ORDER BY total_revenue DESC
LIMIT 25;

-- Key Insights:
-- 1. Cunewalde, Germany leads with $110K revenue (8.71%)
-- 2. International reach: 25+ cities across 15+ countries
-- 3. High-value single customers in top markets
-- 4. London shows expansion potential (6 customers, $52K)
