-- Business Question: Which products drive the most revenue?

WITH product_performance AS (
    SELECT 
        p.product_id,
        p.product_name,
        c.category_name,
        SUM(od.quantity) as total_quantity_sold,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) as total_revenue,
        COUNT(DISTINCT o.customer_id) as unique_customers,
        COUNT(DISTINCT o.order_id) as total_orders,
        AVG(od.unit_price * od.quantity * (1 - od.discount)) as avg_order_value
    FROM products p
    JOIN order_details od ON p.product_id = od.product_id
    JOIN orders o ON od.order_id = o.order_id
    JOIN categories c ON p.category_id = c.category_id
    GROUP BY p.product_id, p.product_name, c.category_name
),
ranked_products AS (
    SELECT 
        *,
        RANK() OVER (ORDER BY total_revenue DESC) as revenue_rank,
        ROUND((total_revenue / SUM(total_revenue) OVER () * 100)::numeric, 2) as revenue_share_pct
    FROM product_performance
)
SELECT 
    product_name,
    category_name,
    total_quantity_sold,
    ROUND(total_revenue::numeric, 2) as total_revenue,
    unique_customers,
    total_orders,
    ROUND(avg_order_value::numeric, 2) as avg_order_value,
    revenue_rank,
    revenue_share_pct,
    CASE 
        WHEN revenue_rank <= 5 THEN '⭐ Top Performer'
        WHEN revenue_rank <= 15 THEN '✅ Strong Performer'
        WHEN revenue_rank <= 30 THEN '⚠️ Average Performer'
        ELSE '🔴 Underperformer'
    END as performance_tier
FROM ranked_products 
ORDER BY revenue_rank
LIMIT 20;

-- Key Insights:
-- 1. Côte de Blaye (Beverages) leads with $141K revenue (11.17%)
-- 2. Top 5 products generate 33% of total revenue
-- 3. Premium positioning strategy working well
-- 4. Beverages and Dairy categories dominate
