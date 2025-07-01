-- Automated reporting functions for business users

-- 1. Monthly Revenue Report Automation
CREATE OR REPLACE FUNCTION get_monthly_revenue_report(
    start_date DATE DEFAULT '1996-01-01',
    end_date DATE DEFAULT '1998-12-31'
)
RETURNS TABLE(
    month TEXT,
    total_revenue NUMERIC,
    total_orders BIGINT,
    unique_customers BIGINT,
    avg_order_value NUMERIC,
    growth_rate NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH monthly_data AS (
        SELECT 
            DATE_TRUNC('month', o.order_date) as month_date,
            SUM(od.unit_price * od.quantity * (1 - od.discount)) as revenue,
            COUNT(DISTINCT o.order_id) as orders,
            COUNT(DISTINCT o.customer_id) as customers,
            AVG(od.unit_price * od.quantity * (1 - od.discount)) as avg_value
        FROM orders o
        INNER JOIN order_details od ON o.order_id = od.order_id
        WHERE o.order_date BETWEEN start_date AND end_date
        GROUP BY DATE_TRUNC('month', o.order_date)
    ),
    with_growth AS (
        SELECT 
            month_date,
            revenue,
            orders,
            customers,
            avg_value,
            ROUND(((revenue - LAG(revenue) OVER (ORDER BY month_date)) / 
                   NULLIF(LAG(revenue) OVER (ORDER BY month_date), 0) * 100)::numeric, 2) as growth_pct
        FROM monthly_data
    )
    SELECT 
        TO_CHAR(month_date, 'YYYY-MM'),
        ROUND(revenue::numeric, 2),
        orders,
        customers,
        ROUND(avg_value::numeric, 2),
        growth_pct
    FROM with_growth
    ORDER BY month_date;
END;
$$ LANGUAGE plpgsql;

-- 2. Customer Segmentation Automation
CREATE OR REPLACE FUNCTION get_customer_segments()
RETURNS TABLE(
    customer_id VARCHAR(5),
    company_name VARCHAR(40),
    country VARCHAR(15),
    total_spent NUMERIC,
    order_count BIGINT,
    days_since_last_order INTEGER,
    customer_segment TEXT,
    action_priority TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH customer_metrics AS (
        SELECT 
            c.customer_id,
            c.company_name,
            c.country,
            SUM(od.unit_price * od.quantity * (1 - od.discount)) as spent,
            COUNT(o.order_id) as orders,
            (DATE '1998-05-06' - MAX(o.order_date)) as days_since_last
        FROM customers c
        INNER JOIN orders o ON c.customer_id = o.customer_id
        INNER JOIN order_details od ON o.order_id = od.order_id
        GROUP BY c.customer_id, c.company_name, c.country
    ),
    rfm_scores AS (
        SELECT 
            *,
            NTILE(5) OVER (ORDER BY days_since_last DESC) as recency_score,
            NTILE(5) OVER (ORDER BY orders ASC) as frequency_score,
            NTILE(5) OVER (ORDER BY spent ASC) as monetary_score
        FROM customer_metrics
    )
    SELECT 
        rs.customer_id::VARCHAR(5),
        rs.company_name::VARCHAR(40),
        rs.country::VARCHAR(15),
        ROUND(rs.spent::numeric, 2),
        rs.orders,
        rs.days_since_last,
        CASE 
            WHEN recency_score + frequency_score + monetary_score >= 12 THEN 'Champions'
            WHEN recency_score + frequency_score + monetary_score >= 9 THEN 'Loyal Customers'
            WHEN recency_score >= 4 AND frequency_score <= 2 THEN 'New Customers'
            WHEN recency_score <= 2 AND frequency_score >= 4 THEN 'At Risk'
            ELSE 'Standard'
        END::TEXT,
        CASE 
            WHEN recency_score + frequency_score + monetary_score >= 12 THEN '🏆 VIP Treatment'
            WHEN recency_score + frequency_score + monetary_score >= 9 THEN '💎 Retention Focus'
            WHEN recency_score >= 4 AND frequency_score <= 2 THEN '📈 Growth Opportunity'
            WHEN recency_score <= 2 AND frequency_score >= 4 THEN '🚨 Immediate Action'
            ELSE '📊 Standard Care'
        END::TEXT
    FROM rfm_scores rs
    ORDER BY rs.spent DESC;
END;
$$ LANGUAGE plpgsql;

-- Usage Examples:
-- SELECT * FROM get_monthly_revenue_report();
-- SELECT * FROM get_customer_segments() LIMIT 20;

-- Business Value:
-- 1. Automated monthly reporting eliminates manual query writing
-- 2. Instant customer segmentation for marketing campaigns
-- 3. Business users can access complex analytics via simple function calls
-- 4. Production-ready automation for enterprise environments
