-- DAY 2: Revenue Analysis with Growth Trends
-- Business Question: How is our revenue trending month-over-month?

WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', o.order_date) as month,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) as total_revenue,
        COUNT(DISTINCT o.order_id) as total_orders,
        COUNT(DISTINCT o.customer_id) as unique_customers,
        AVG(od.unit_price * od.quantity * (1 - od.discount)) as avg_order_value
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    WHERE o.order_date IS NOT NULL
    GROUP BY DATE_TRUNC('month', o.order_date)
),
revenue_with_growth AS (
    SELECT 
        month,
        total_revenue,
        total_orders,
        unique_customers,
        avg_order_value,
        LAG(total_revenue) OVER (ORDER BY month) as prev_month_revenue,
        ROUND(
            ((total_revenue - LAG(total_revenue) OVER (ORDER BY month)) / 
            NULLIF(LAG(total_revenue) OVER (ORDER BY month), 0) * 100)::numeric, 2
        ) as revenue_growth_pct
    FROM monthly_revenue
)
SELECT 
    TO_CHAR(month, 'YYYY-MM') as month,
    ROUND(total_revenue::numeric, 2) as revenue,
    total_orders,
    unique_customers,
    ROUND(avg_order_value::numeric, 2) as avg_order_value,
    revenue_growth_pct,
    CASE 
        WHEN revenue_growth_pct > 10 THEN '🔥 High Growth'
        WHEN revenue_growth_pct > 0 THEN '📈 Growing'
        WHEN revenue_growth_pct < -10 THEN '📉 Declining'
        ELSE '➡️ Stable'
    END as growth_status
FROM revenue_with_growth 
ORDER BY month;

-- Key Insights:
-- 1. Revenue ranges from $18K to $123K per month
-- 2. High volatility: -85% to +64% growth rates
-- 3. Clear seasonal patterns with Q4 spikes
-- 4. December 1997 was peak month with 64% growth
