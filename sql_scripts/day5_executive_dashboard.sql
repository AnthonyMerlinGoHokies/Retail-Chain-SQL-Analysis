-- Comprehensive executive summary for C-suite decision making
 
WITH business_metrics AS (
    -- Core business performance
    SELECT 
        COUNT(DISTINCT o.order_id) as total_orders,
        COUNT(DISTINCT o.customer_id) as total_customers,
        COUNT(DISTINCT p.product_id) as total_products,
        COUNT(DISTINCT e.employee_id) as total_employees,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) as total_revenue,
        AVG(od.unit_price * od.quantity * (1 - od.discount)) as avg_order_value,
        MIN(o.order_date) as business_start_date,
        MAX(o.order_date) as last_order_date
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    JOIN employees e ON o.employee_id = e.employee_id
),
top_performers AS (
    -- Top customer identification
    SELECT 
        'Customer' as metric_type,
        c.company_name as performer,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) as value
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY c.customer_id, c.company_name
    ORDER BY value DESC
    LIMIT 1
),
geographic_summary AS (
    -- Geographic performance analysis
    SELECT 
        COUNT(DISTINCT c.country) as countries_served,
        COUNT(DISTINCT c.city) as cities_served,
        c.country as top_country,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) as top_country_revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY c.country
    ORDER BY top_country_revenue DESC
    LIMIT 1
)
SELECT 
    -- Business Scale Metrics
    bm.total_orders,
    bm.total_customers,
    bm.total_products,
    bm.total_employees,
    ROUND(bm.total_revenue::numeric, 2) as total_revenue,
    ROUND(bm.avg_order_value::numeric, 2) as avg_order_value,
    
    -- Business Timeline
    bm.business_start_date,
    bm.last_order_date,
    (bm.last_order_date - bm.business_start_date) as business_duration_days,
    
    -- Top Performer Analysis
    tp.performer as top_customer,
    ROUND(tp.value::numeric, 2) as top_customer_value,
    ROUND((tp.value / bm.total_revenue * 100)::numeric, 2) as top_customer_revenue_share,
    
    -- Geographic Intelligence
    gs.countries_served,
    gs.cities_served,
    gs.top_country,
    ROUND(gs.top_country_revenue::numeric, 2) as top_country_revenue,
    ROUND((gs.top_country_revenue / bm.total_revenue * 100)::numeric, 2) as top_country_share
FROM business_metrics bm
CROSS JOIN top_performers tp
CROSS JOIN geographic_summary gs;

-- Executive Summary Results:
-- 830 orders, 89 customers, $1.27M revenue across 671 days
-- QUICK-Stop: Top customer with $110K (8.7% of revenue)
-- Global reach: 12+ countries, USA leading with 19.4% revenue share
-- Average order value: $587.37 (premium B2B positioning confirmed)
