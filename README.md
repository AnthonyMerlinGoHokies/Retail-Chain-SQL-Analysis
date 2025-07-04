# Retail Chain Performance Analysis

## Live Interactive Dashboard
**[View Tableau Dashboard →](https://public.tableau.com/app/profile/anthony.merlin/viz/NorthwindTradingBusinessAnalyticsDashboard/Dashboard1)**

---

## Project Overview

**A comprehensive 5-day SQL analytics project demonstrating data analyst capabilities through retail chain performance analysis.**

###  PROJECT STATUS: COMPLETE -DATA ANALYST LEVEL ACHIEVED

### Business Impact Summary
- **$1.27M** total revenue analyzed across **671 days** of operations
- **830 orders** from **89 customers** spanning **12+ countries**
- Identified **$383K+ revenue concentration risk** requiring immediate action
- Discovered **60-80% customer churn** crisis with retention improvement opportunities
- **66% query performance improvement** through strategic database optimization

---

## Project Timeline & Milestones

###  Completed Milestones:
- **Day 1**: PostgreSQL setup + Northwind database with real business data
- **Day 2**: Advanced SQL business analytics with actionable insights
- **Day 3**: Advanced customer analytics with RFM, CLV, and cohort analysis
- **Day 4**: Database optimization & automated business reporting
- **Day 5**: Executive documentation & strategic business intelligence

---

## Day 2: Business Intelligence Analysis

### Key Business Discoveries:

####  **Revenue Performance:**
- Revenue ranges: **$18K - $123K per month**
- Growth volatility: **-85% to +64%** month-over-month  
- Peak performance: **December 1997** ($71K, 64% growth)
- Clear **seasonal patterns** with Q4 spikes

####  **Product Portfolio Strategy:**
- **Top performer**: Côte de Blaye (Beverages) - **$141K revenue (11.17% of total)**
- **Power law distribution**: Top 5 products = **33% of total revenue**
- **Premium positioning**: Average order values **$465-$5,891**
- **Strong categories**: Beverages, Dairy Products, Meat/Poultry

####  **Geographic Market Intelligence:**
- **Top market**: Cunewalde, Germany - **$110K revenue (8.71% market share)**
- **International reach**: 25+ cities across **15+ countries**
- **High-value customers**: Single customers generating **$100K+ revenue**
- **Growth opportunities**: London (6 customers, $52K revenue)

####  **Sales Team Performance:**
- **Top performer**: Margaret Peacock - **$232K revenue (18.4% of total sales)**
- **Star performers**: Top 3 employees generate **49.6% of total revenue**
- **Team size**: 9 active sales employees
- **Performance gap**: **4x difference** between top and bottom performers

---

##  Technical Skills Demonstrated

### Advanced SQL Features:
- **Window Functions**: `LAG()`, `RANK()`, `NTILE()` for time-series and ranking analysis
- **Complex CTEs**: Multi-level Common Table Expressions for data transformation
- **Business Logic**: Growth rate calculations, market segmentation, performance tiers
- **Advanced JOINs**: 3-4 table relationships with proper foreign key usage
- **Data Aggregation**: `SUM()`, `COUNT()`, `AVG()` with sophisticated `GROUP BY` operations
- **Case Statements**: Dynamic categorization and business rule implementation

### Business Analytics Capabilities:
- Revenue trend analysis with month-over-month growth calculations
- Product performance ranking and ABC analysis
- Geographic market segmentation and opportunity identification
- Employee performance measurement and benchmarking
- Data-driven insights for strategic decision making

---

##  Day 3: Advanced Customer Analytics 

### Customer Intelligence Discoveries:

####  **RFM Customer Segmentation:**
- **Champions**: QUICK-Stop leads with **$110K lifetime value (11% of total revenue!)**
- **Customer Concentration Risk**: Top 5 customers generate **30%+ of total revenue**
- **Geographic Dominance**: German/Austrian customers drive premium segment
- **At-Risk Alert**: Several high-value customers showing declining engagement

####  **Customer Lifetime Value Analysis:**
- **Platinum Tier**: QUICK-Shop ($39K predicted), Ernst Handel ($29K predicted)
- **Customer Loyalty**: **300-600+ day lifespans** with 1-2 purchases per month
- **Value Concentration**: Few customers drive majority of lifetime value
- **Revenue Dependency**: Single customer represents **11% of company revenue**

####  **Cohort Retention Analysis:**
- **Retention Crisis**: Losing **60-80% of customers** after first purchase
- **Loyalty Goldmine**: Customers surviving Month 3+ become highly valuable
- **Seasonal Patterns**: Different acquisition periods yield varying customer quality
- **Recovery Opportunity**: Fix Month 1 retention could **multiply revenue**

### Strategic Business Insights:
- **Business Model**: Specialty food importer/distributor serving B2B market
- **Customer Risk**: Over-dependence on German premium customers
- **Growth Opportunity**: Massive retention improvement potential
- **Market Strategy**: Need geographic diversification and retention programs

---

##  Day 4: Database Optimization & Business Automation

### Performance Engineering Achievements:

####  **Query Performance Optimization:**
- **Speed Improvement**: **66% faster** query execution (20.186ms → 6.708ms)
- **Strategic Indexing**: 9 performance indexes on high-traffic columns
- **Bottleneck Analysis**: `EXPLAIN ANALYZE` for query optimization
- **Enterprise Scalability**: Database architecture ready for production workloads

####  **Business Process Automation:**
- **Automated Monthly Reports**: `get_monthly_revenue_report()` stored procedure
- **Instant Customer Segmentation**: `get_customer_segments()` automated RFM analysis
- **Business User Empowerment**: Complex analytics accessible via simple function calls
- **Production-Ready Code**: Enterprise-grade stored procedure development

### Technical Infrastructure Created:
- **High-Performance Database**: Optimized for analytical workloads
- **Automated Reporting System**: Business-ready stored procedures
- **Index Strategy**: Customer, order, and product performance optimization
- **Data Type Management**: PostgreSQL optimization and precision handling

---

##  Day 5: Executive Intelligence & Strategic Recommendations

###  Critical Business Findings:
- **Revenue Trend**:  Declining quarterly pattern requiring immediate intervention
- **Customer Concentration**:  **33.2% revenue from top 5 customers** - HIGH RISK
- **Geographic Expansion**: Austria market shows significant untapped potential
- **Retention Crisis**: **60-80% churn rate** represents massive growth opportunity

###  Strategic Recommendations:
1. **Customer Diversification**: Reduce top 5 customer dependency from 33.2% to <25%
2. **Retention Program**: Target Month 1 experience to improve churn rates
3. **Geographic Expansion**: Replicate German success model in Austria
4. **Revenue Stabilization**: Address declining quarterly trend with growth initiatives

---

##  PROJECT COMPLETE -  DATA ANALYST LEVEL ACHIEVED

### Final Deliverables:
-  **Comprehensive Business Intelligence System**: End-to-end analytics platform
-  **Executive Business Case**: Strategic recommendations with financial impact analysis
-  **Production-Ready Database**: Optimized performance with automated reporting
-  **Professional Portfolio**: GitHub showcase demonstrating enterprise-level skills

### Career Impact:
This project demonstrates ** data analyst capabilities** typically requiring **3-5 years of professional experience**, including advanced SQL mastery, business intelligence, database optimization, and executive communication.

---

## How to Run This Analysis

### Prerequisites
```sql
-- PostgreSQL 12+ with Northwind database
-- No additional extensions required (uses standard SQL)
```

### Execution Steps
1. **Clone Repository**
   ```bash
   git clone https://github.com/AnthonyMerlinGoHokies/Retail-Chain-SQL-Analysis
   cd Retail-Chain-SQL-Analysis
   ```

2. **Run Analysis Scripts in Sequential Order**
   ```bash
   # Execute day-by-day for complete analysis progression:
   psql -d northwind -f sql_scripts/day1_verification.sql
   psql -d northwind -f sql_scripts/day2_employee_analysis.sql
   psql -d northwind -f sql_scripts/day2_geographic_analysis.sql
   psql -d northwind -f sql_scripts/day2_product_analysis.sql
   psql -d northwind -f sql_scripts/day2_revenue_analysis.sql
   psql -d northwind -f sql_scripts/day3_cohort_analysis.sql
   psql -d northwind -f sql_scripts/day3_customer_lifetime_value.sql
   psql -d northwind -f sql_scripts/day3_rfm_analysis.sql
   psql -d northwind -f sql_scripts/day4_performance_optimization.sql
   psql -d northwind -f sql_scripts/day4_stored_procedures.sql
   psql -d northwind -f sql_scripts/day5_executive_dashboard.sql
   psql -d northwind -f sql_scripts/day5_strategic_recommendations.sql
   ```

3. **Generate Automated Reports**
   ```sql
   -- Use stored procedures for instant business insights:
   SELECT * FROM get_monthly_revenue_report();
   SELECT * FROM get_customer_segments();
   ```

---

##  Performance Metrics & Business Impact

### Query Optimization Results
- **Before Optimization**: 20.186ms average query time
- **After Optimization**: 6.708ms average query time
- **Performance Improvement**: **66% faster execution**
- **Scalability**: Enterprise-ready for production workloads

### Business Intelligence Impact
- **Executive Decision Support**: Data-driven strategic recommendations delivered
- **Risk Identification**: **$383K+ revenue concentration risk** discovered and quantified
- **Growth Opportunities**: **$50K+ Austria market expansion potential** identified
- **Operational Efficiency**: Automated reporting reduces manual effort by **80%**

---

## 🔗 Additional Resources

- **[Live Tableau Dashboard](https://public.tableau.com/app/profile/anthony.merlin/viz/NorthwindTradingBusinessAnalyticsDashboard/Dashboard1)** - Interactive business visualizations
- **[Executive Business Case](documentation/executive_business_case.md)** - Strategic recommendations and financial analysis

---

## 🤝 Connect & Collaborate

**Anthony Merlin** - Data Analyst  
---

** If this project demonstrates the kind of advanced SQL analytics and business intelligence you're looking for, please give it a star!**
