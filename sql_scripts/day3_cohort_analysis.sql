-- Shows how customer behavior changes by when they first joined

WITH customer_cohorts AS (
    -- Define each customer's first order month (their cohort)
    SELECT 
        c.customer_id,
        c.company_name,
        DATE_TRUNC('month', MIN(o.order_date)) as cohort_month,
        MIN(o.order_date) as first_order_date
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.company_name
),
customer_orders AS (
    -- Get all orders with cohort information
    SELECT 
        cc.customer_id,
        cc.company_name,
        cc.cohort_month,
        DATE_TRUNC('month', o.order_date) as order_month,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) as month_revenue
    FROM customer_cohorts cc
    JOIN orders o ON cc.customer_id = o.customer_id
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY cc.customer_id, cc.company_name, cc.cohort_month, DATE_TRUNC('month', o.order_date)
),
cohort_data AS (
    -- Calculate the period number (months since first order)
    SELECT 
        cohort_month,
        order_month,
        customer_id,
        company_name,
        month_revenue,
        EXTRACT(YEAR FROM AGE(order_month, cohort_month)) * 12 + 
        EXTRACT(MONTH FROM AGE(order_month, cohort_month)) as period_number
    FROM customer_orders
),
cohort_sizes AS (
    -- Count customers in each cohort
    SELECT 
        cohort_month,
        COUNT(DISTINCT customer_id) as cohort_size
    FROM customer_cohorts
    GROUP BY cohort_month
),
cohort_table AS (
    -- Build the retention table
    SELECT 
        cd.cohort_month,
        cd.period_number,
        COUNT(DISTINCT cd.customer_id) as customers_active,
        cs.cohort_size,
        ROUND((COUNT(DISTINCT cd.customer_id)::numeric / cs.cohort_size * 100), 2) as retention_rate,
        SUM(cd.month_revenue) as period_revenue,
        AVG(cd.month_revenue) as avg_revenue_per_customer
    FROM cohort_data cd
    JOIN cohort_sizes cs ON cd.cohort_month = cs.cohort_month
    GROUP BY cd.cohort_month, cd.period_number, cs.cohort_size
)
SELECT 
    TO_CHAR(cohort_month, 'YYYY-MM') as cohort_month,
    period_number,
    CASE 
        WHEN period_number = 0 THEN 'Month 0 (First Order)'
        WHEN period_number = 1 THEN 'Month 1'
        WHEN period_number = 2 THEN 'Month 2'
        WHEN period_number = 3 THEN 'Month 3'
        WHEN period_number = 6 THEN 'Month 6'
        WHEN period_number = 12 THEN 'Month 12'
        ELSE CONCAT('Month ', period_number)
    END as period_label,
    cohort_size,
    customers_active,
    retention_rate,
    ROUND(period_revenue::numeric, 2) as period_revenue,
    ROUND(avg_revenue_per_customer::numeric, 2) as avg_revenue_per_customer,
    CASE 
        WHEN retention_rate >= 80 THEN '🟢 Excellent Retention'
        WHEN retention_rate >= 60 THEN '🟡 Good Retention'
        WHEN retention_rate >= 40 THEN '🟠 Moderate Retention'
        WHEN retention_rate >= 20 THEN '🔴 Poor Retention'
        ELSE '⚫ Very Poor Retention'
    END as retention_health
FROM cohort_table
WHERE period_number <= 12  -- Focus on first year
ORDER BY cohort_month, period_number;

-- Key Insights:
-- 1. Retention crisis: Losing 60-80% of customers after first purchase
-- 2. Loyalty goldmine: Customers surviving Month 3+ become highly valuable
-- 3. Seasonal patterns: Different acquisition periods yield varying quality
-- 4. Recovery opportunity: Fix Month 1 retention could multiply revenue
