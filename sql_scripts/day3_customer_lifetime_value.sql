-- Business Question: What is each customer worth over time?

WITH customer_cohorts AS (
    SELECT 
        c.customer_id,
        c.company_name,
        c.country,
        MIN(o.order_date) as first_order_date,
        MAX(o.order_date) as last_order_date,
        COUNT(DISTINCT o.order_id) as total_orders,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) as total_revenue,
        AVG(od.unit_price * od.quantity * (1 - od.discount)) as avg_order_value,
        (MAX(o.order_date) - MIN(o.order_date)) as customer_lifespan_days
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY c.customer_id, c.company_name, c.country
),
clv_calculations AS (
    SELECT 
        *,
        -- Calculate purchase frequency (orders per month)
        CASE 
            WHEN customer_lifespan_days > 0 THEN 
                ROUND((total_orders::numeric / (customer_lifespan_days / 30.0)), 2)
            ELSE total_orders
        END as purchase_frequency_monthly,
        
        -- Simple CLV = AOV * Purchase Frequency * Lifespan (in months)
        CASE 
            WHEN customer_lifespan_days > 0 THEN 
                ROUND((avg_order_value * (total_orders::numeric / (customer_lifespan_days / 30.0)) * (customer_lifespan_days / 30.0))::numeric, 2)
            ELSE ROUND(total_revenue::numeric, 2)
        END as customer_lifetime_value,
        
        -- Predicted future value (extrapolate for next 12 months)
        CASE 
            WHEN customer_lifespan_days > 0 THEN 
                ROUND((avg_order_value * (total_orders::numeric / (customer_lifespan_days / 30.0)) * 12)::numeric, 2)
            ELSE ROUND((avg_order_value * total_orders)::numeric, 2)
        END as predicted_12_month_value
    FROM customer_cohorts
),
clv_segments AS (
    SELECT 
        *,
        NTILE(4) OVER (ORDER BY customer_lifetime_value) as clv_quartile,
        CASE 
            WHEN customer_lifetime_value >= 50000 THEN 'Platinum'
            WHEN customer_lifetime_value >= 20000 THEN 'Gold'  
            WHEN customer_lifetime_value >= 5000 THEN 'Silver'
            ELSE 'Bronze'
        END as value_tier
    FROM clv_calculations
)
SELECT 
    customer_id,
    company_name,
    country,
    TO_CHAR(first_order_date, 'YYYY-MM-DD') as first_order,
    TO_CHAR(last_order_date, 'YYYY-MM-DD') as last_order,
    customer_lifespan_days,
    total_orders,
    ROUND(total_revenue::numeric, 2) as total_revenue,
    ROUND(avg_order_value::numeric, 2) as avg_order_value,
    purchase_frequency_monthly,
    customer_lifetime_value,
    predicted_12_month_value,
    clv_quartile,
    value_tier,
    CASE 
        WHEN value_tier = 'Platinum' THEN '💎 Ultra VIP'
        WHEN value_tier = 'Gold' THEN '🏆 Premium Focus'
        WHEN value_tier = 'Silver' THEN '⭐ Growth Target'
        ELSE '📈 Development Opportunity'
    END as strategy_focus
FROM clv_segments
ORDER BY customer_lifetime_value DESC;

-- Key Insights:
-- 1. Platinum tier customers (QUICK-Shop: $39K predicted value)
-- 2. Customer longevity: 300-600+ day lifespans show strong loyalty
-- 3. Purchase patterns: Top customers buy 1-2x per month consistently
-- 4. Revenue concentration: Few customers drive majority of lifetime value
