/*=============================================================================================
   SQL Script: analysis_queries.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script contains advanced analysis queries for the `contracts` table, designed to provide 
   actionable insights into key business metrics, including:
   ➜ Total spending per category
   ➜ Vendor performance metrics
   ➜ Spending trends over time
   ➜ Contract duration analysis
   ➜ Vendor rankings by spending and contract count
   ➜ Identification of potential data issues

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Structured queries optimized for performance and clarity.
   ➜ Provides flexibility for filtering and grouping data to meet diverse analysis needs.
   ➜ Supports result review and export for reporting purposes.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `analysis_queries.sql`.
   2️⃣ Open MySQL Workbench or another SQL-compatible environment.
   3️⃣ Execute the script to retrieve results for each query step.
   4️⃣ Review query outputs in the result pane or export them for additional analysis.

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Customize query filters to focus on specific business metrics or categories.
   ➤ Export query results to external files (e.g., CSV) for downstream processing.
   ➤ Integrate additional ranking or grouping logic to enhance insights.

   ⚠️ Troubleshooting:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `contracts` table contains cleaned and validated data before running this script.
   ⚙ Verify query syntax is compatible with your database engine (e.g., MySQL, MariaDB).
   ⚙ Check database permissions if certain queries fail unexpectedly.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
The main script starts here. Run the queries sequentially to analyze spending patterns, vendor 
performance, and other key business metrics. Ensure prerequisites are met. Happy querying!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Step 1: Total Spending by Category
SELECT 
    CAT_DSCR AS category,
    SUM(MA_PRCH_LMT_AM) AS total_spending,
    ROUND(SUM(MA_PRCH_LMT_AM) * 100 / SUM(SUM(MA_PRCH_LMT_AM)) OVER (), 2) AS percentage_of_total
FROM contracts
GROUP BY CAT_DSCR
ORDER BY total_spending DESC;

-- Step 2: Vendor Performance Metrics
-- Top 10 Vendors by Total Spending
SELECT 
    LGL_NM AS vendor_name,
    COUNT(*) AS contract_count,
    SUM(MA_PRCH_LMT_AM) AS total_spending
FROM contracts
GROUP BY LGL_NM
ORDER BY total_spending DESC
LIMIT 10;

-- Step 3: Spending Trends Over Time
-- Monthly Spending Trends
SELECT 
    DATE_FORMAT(EFBGN_DT, '%Y-%m') AS month,
    SUM(MA_PRCH_LMT_AM) AS monthly_spending
FROM contracts
WHERE EFBGN_DT IS NOT NULL
GROUP BY DATE_FORMAT(EFBGN_DT, '%Y-%m')
ORDER BY month;

-- Step 4: Contract Duration Analysis
-- Average and Maximum Contract Duration
SELECT 
    AVG(contract_duration) AS average_duration_days,
    MAX(contract_duration) AS longest_duration_days
FROM contracts;

-- Step 5: Vendor Rankings
-- Ranking Vendors by Spending and Contract Count
SELECT 
    LGL_NM AS vendor_name,
    RANK() OVER (ORDER BY SUM(MA_PRCH_LMT_AM) DESC) AS spending_rank,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS contract_count_rank
FROM contracts
GROUP BY LGL_NM;

-- Step 6: Potential Data Issues
-- Identify Contracts with Spending > $10,000,000
SELECT 
    ROW_KEY,
    LGL_NM AS vendor_name,
    MA_PRCH_LMT_AM AS spending
FROM contracts
WHERE MA_PRCH_LMT_AM > 10000000;

-- Step 7: Summary of Key Insights
-- Total Number of Contracts, Vendors, and Average Spending
SELECT 
    COUNT(*) AS total_contracts,
    COUNT(DISTINCT LGL_NM) AS total_vendors,
    AVG(MA_PRCH_LMT_AM) AS average_spending_per_contract
FROM contracts;