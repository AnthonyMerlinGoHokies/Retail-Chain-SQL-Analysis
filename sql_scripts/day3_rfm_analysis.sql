-- RFM = Recency (how recently), Frequency (how often), Monetary (how much)

WITH customer_metrics AS (
    SELECT 
        c.customer_id,
        c.company_name,
        c.country,
        MAX(o.order_date) as last_order_date,
        COUNT(DISTINCT o.order_id) as order_frequency,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) as total_spent,
        AVG(od.unit_price * od.quantity * (1 - od.discount)) as avg_order_value,
        (MAX(o.order_date) - MIN(o.order_date)) as customer_lifespan_days
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    LEFT JOIN order_details od ON o.order_id = od.order_id
    WHERE o.order_date IS NOT NULL
    GROUP BY c.customer_id, c.company_name, c.country
),
rfm_calculations AS (
    SELECT 
        *,
        -- Recency: Days since last order (lower is better)
        (DATE '1998-05-06' - last_order_date) as days_since_last_order,
        
        -- RFM Scores (1-5 scale, 5 is best)
        NTILE(5) OVER (ORDER BY (DATE '1998-05-06' - last_order_date) DESC) as recency_score,
        NTILE(5) OVER (ORDER BY order_frequency ASC) as frequency_score,
        NTILE(5) OVER (ORDER BY total_spent ASC) as monetary_score
    FROM customer_metrics
),
rfm_segments AS (
    SELECT 
        *,
        CONCAT(recency_score, frequency_score, monetary_score) as rfm_score,
        CASE 
            WHEN recency_score >= 4 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'Champions'
            WHEN recency_score >= 3 AND frequency_score >= 3 AND monetary_score >= 3 THEN 'Loyal Customers'
            WHEN recency_score >= 4 AND frequency_score <= 2 THEN 'New Customers'
            WHEN recency_score >= 3 AND frequency_score <= 2 AND monetary_score >= 3 THEN 'Potential Loyalists'
            WHEN recency_score <= 2 AND frequency_score >= 4 AND monetary_score >= 4 THEN 'At Risk'
            WHEN recency_score <= 2 AND frequency_score >= 2 AND monetary_score >= 2 THEN 'Cannot Lose Them'
            WHEN recency_score <= 2 AND frequency_score <= 2 AND monetary_score >= 3 THEN 'Hibernating'
            ELSE 'Lost Customers'
        END as customer_segment
    FROM rfm_calculations
)
SELECT 
    customer_id,
    company_name,
    country,
    TO_CHAR(last_order_date, 'YYYY-MM-DD') as last_order_date,
    days_since_last_order,
    order_frequency,
    ROUND(total_spent::numeric, 2) as total_spent,
    ROUND(avg_order_value::numeric, 2) as avg_order_value,
    customer_lifespan_days,
    rfm_score,
    recency_score,
    frequency_score, 
    monetary_score,
    customer_segment,
    CASE 
        WHEN customer_segment = 'Champions' THEN '🏆 VIP Treatment'
        WHEN customer_segment = 'Loyal Customers' THEN '💎 Retention Focus'
        WHEN customer_segment = 'At Risk' THEN '🚨 Immediate Action'
        WHEN customer_segment = 'Cannot Lose Them' THEN '⚡ Win-Back Campaign'
        ELSE '📈 Growth Opportunity'
    END as action_priority
FROM rfm_segments
ORDER BY total_spent DESC;

-- Key Insights:
-- 1. QUICK-Stop is Champion customer with $110K lifetime value (11% of revenue)
-- 2. Top 5 customers generate 30%+ of total revenue (concentration risk)
-- 3. German/Austrian customers dominate premium segments
-- 4. Several high-value customers showing declining engagement need attention
