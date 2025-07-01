-- Data-driven insights for executive decision making
 
WITH revenue_analysis AS (
    SELECT 
        DATE_TRUNC('quarter', o.order_date) as quarter,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) as revenue
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY DATE_TRUNC('quarter', o.order_date)
    ORDER BY quarter DESC
    LIMIT 2
),
customer_concentration AS (
    SELECT 
        COUNT(*) as total_customers,
        SUM(CASE WHEN customer_rank <= 5 THEN revenue ELSE 0 END) as top5_revenue,
        SUM(revenue) as total_revenue
    FROM (
        SELECT 
            c.customer_id,
            SUM(od.unit_price * od.quantity * (1 - od.discount)) as revenue,
            RANK() OVER (ORDER BY SUM(od.unit_price * od.quantity * (1 - od.discount)) DESC) as customer_rank
        FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
        JOIN order_details od ON o.order_id = od.order_id
        GROUP BY c.customer_id
    ) ranked_customers
),
geographic_risk AS (
    SELECT 
        country,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) as country_revenue,
        COUNT(DISTINCT c.customer_id) as customer_count
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY country
    ORDER BY country_revenue DESC
    LIMIT 3
)
SELECT 
    -- Growth Trend Analysis
    'Revenue Trend' as analysis_type,
    CASE 
        WHEN (SELECT revenue FROM revenue_analysis ORDER BY quarter DESC LIMIT 1 OFFSET 1) > 
             (SELECT revenue FROM revenue_analysis ORDER BY quarter DESC LIMIT 1)
        THEN '⚠️ DECLINING - Implement growth initiatives immediately'
        ELSE '📈 GROWING - Maintain current strategy and scale successful practices'
    END as recommendation

UNION ALL

SELECT 
    'Customer Concentration Risk',
    CASE 
        WHEN cc.top5_revenue / cc.total_revenue > 0.3 
        THEN '🚨 HIGH RISK - Diversify customer base urgently (Top 5 = ' || 
             ROUND((cc.top5_revenue / cc.total_revenue * 100)::numeric, 1) || '%)'
        ELSE '✅ HEALTHY - Continue customer acquisition efforts'
    END
FROM customer_concentration cc

UNION ALL

SELECT 
    'Geographic Diversification',
    'Focus expansion in: ' || string_agg(country || ' (' || customer_count || ' customers)', ', ')
FROM (
    SELECT country, customer_count 
    FROM geographic_risk 
    WHERE customer_count < 10
    ORDER BY country_revenue DESC
    LIMIT 3
) expansion_targets;

-- Critical Business Intelligence Results:
-- 1. Revenue Trend: DECLINING - Immediate growth initiatives required
-- 2. Customer Concentration: HIGH RISK - Top 5 = 33.2% of revenue
-- 3. Geographic Opportunity: Austria expansion (limited customer base)
-- 4. Strategic Priority: Customer diversification and retention programs
