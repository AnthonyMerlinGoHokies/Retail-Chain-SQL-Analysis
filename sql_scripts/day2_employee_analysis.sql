-- Business Question: Which employees are driving the most sales?

WITH employee_performance AS (
    SELECT 
        e.employee_id,
        CONCAT(e.first_name, ' ', e.last_name) as employee_name,
        e.title,
        COUNT(DISTINCT o.order_id) as total_orders,
        COUNT(DISTINCT o.customer_id) as unique_customers,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) as total_revenue,
        AVG(od.unit_price * od.quantity * (1 - od.discount)) as avg_order_value,
        (SUM(od.unit_price * od.quantity * (1 - od.discount)) / COUNT(DISTINCT o.order_id)) as revenue_per_order
    FROM employees e
    LEFT JOIN orders o ON e.employee_id = o.employee_id
    LEFT JOIN order_details od ON o.order_id = od.order_id
    GROUP BY e.employee_id, e.first_name, e.last_name, e.title
    HAVING COUNT(DISTINCT o.order_id) > 0
),
ranked_employees AS (
    SELECT 
        *,
        RANK() OVER (ORDER BY total_revenue DESC) as performance_rank,
        ROUND((total_revenue / SUM(total_revenue) OVER () * 100)::numeric, 2) as revenue_contribution_pct
    FROM employee_performance
)
SELECT 
    employee_name,
    title,
    total_orders,
    unique_customers,
    ROUND(total_revenue::numeric, 2) as total_revenue,
    ROUND(avg_order_value::numeric, 2) as avg_order_value,
    ROUND(revenue_per_order::numeric, 2) as revenue_per_order,
    performance_rank,
    revenue_contribution_pct,
    CASE 
        WHEN performance_rank = 1 THEN '🥇 Top Performer'
        WHEN performance_rank <= 3 THEN '🥈 High Performer'
        WHEN performance_rank <= 6 THEN '🥉 Good Performer'
        ELSE '📊 Standard Performer'
    END as performance_tier
FROM ranked_employees 
ORDER BY total_revenue DESC;

-- Key Insights:
-- 1. Margaret Peacock leads with $232K revenue (18.4%)
-- 2. Top 3 employees generate 49.6% of total revenue
-- 3. 4x performance gap between top and bottom performers
-- 4. Sales Representatives outperform management in revenue generation
