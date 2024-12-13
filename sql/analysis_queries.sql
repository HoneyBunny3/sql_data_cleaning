/*
PL/SQL Script: analysis_queries.sql
-------------------------------------------
Purpose:
This script contains analysis queries for the `contracts` table to provide insights into spending and contract data. Key metrics include:
1. Total spending per category.
2. Vendor performance metrics.
3. Spending trends over time.
4. Contract duration analysis.
5. Vendor rankings based on spending and contract count.

Features:
1. Error handling for each query to provide meaningful feedback.
2. Uses `DBMS_OUTPUT.PUT_LINE` to log results and errors for debugging.
3. Supports dynamic query execution with iteration over results.

Execution Notes:
- Ensure the `contracts` table contains cleaned data before running this script.
- Use `DBMS_OUTPUT.PUT_LINE` to log outputs or errors during execution.
- Enable `SERVEROUTPUT` in your environment to view output logs.
*/

-- Total Spending Per Category
BEGIN
    DBMS_OUTPUT.PUT_LINE('Running: Total Spending Per Category...');
    FOR rec IN (
        SELECT 
            CAT_DSCR AS category,
            SUM(MA_PRCH_LMT_AM) AS total_spent,
            ROUND(SUM(MA_PRCH_LMT_AM) / (SELECT SUM(MA_PRCH_LMT_AM) FROM contracts) * 100, 2) AS percent_contribution
        FROM contracts
        WHERE MA_PRCH_LMT_AM > 0 -- Exclude invalid or zero values
        GROUP BY CAT_DSCR
        ORDER BY total_spent DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Category: ' || rec.category || ' | Total Spent: ' || rec.total_spent || ' | Percent: ' || rec.percent_contribution || '%');
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in Total Spending Per Category: ' || SQLERRM);
END;
/


-- Count of Contracts by Vendor
BEGIN
    DBMS_OUTPUT.PUT_LINE('Running: Count of Contracts by Vendor...');
    FOR rec IN (
        SELECT 
            LGL_NM AS vendor_name,
            COUNT(*) AS contract_count,
            SUM(MA_PRCH_LMT_AM) AS total_spent,
            ROUND(AVG(MA_PRCH_LMT_AM), 2) AS avg_contract_value
        FROM contracts
        WHERE MA_PRCH_LMT_AM > 0 -- Exclude invalid or zero values
        GROUP BY LGL_NM
        ORDER BY total_spent DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Vendor: ' || rec.vendor_name || ' | Contracts: ' || rec.contract_count || ' | Total Spent: ' || rec.total_spent || ' | Avg Value: ' || rec.avg_contract_value);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in Count of Contracts by Vendor: ' || SQLERRM);
END;
/


-- Spending Trends Over Time (Monthly Granularity)
BEGIN
    DBMS_OUTPUT.PUT_LINE('Running: Spending Trends Over Time...');
    FOR rec IN (
        SELECT 
            EXTRACT(YEAR FROM EFBGN_DT) AS year,
            EXTRACT(MONTH FROM EFBGN_DT) AS month,
            SUM(MA_PRCH_LMT_AM) AS total_spent,
            COUNT(*) AS contract_count
        FROM contracts
        WHERE EFBGN_DT IS NOT NULL AND MA_PRCH_LMT_AM > 0 -- Exclude invalid data
        GROUP BY EXTRACT(YEAR FROM EFBGN_DT), EXTRACT(MONTH FROM EFBGN_DT)
        ORDER BY year, month
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Year: ' || rec.year || ' | Month: ' || rec.month || ' | Total Spent: ' || rec.total_spent || ' | Contracts: ' || rec.contract_count);
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error in Spending Trends Over Time: ' || SQLERRM);
END;
/


-- Instructions for Running the Script
/*
Execution Instructions:
-------------------------------------------
1. Save this script as `analysis_queries.sql`.
2. Open Oracle SQL Developer or another PL/SQL-compatible environment.
3. Enable `DBMS_OUTPUT` by running:
   SET SERVEROUTPUT ON;
4. Execute the script.
5. View the output logs for query results or error messages.

Optional Enhancements:
-------------------------------------------
1. Modify specific queries to include additional filters or metrics.
2. Redirect query results to a table or CSV file for further analysis.
3. Add custom logic for ranking or grouping data if required.

Troubleshooting:
-------------------------------------------
- Ensure the `contracts` table contains cleaned data.
- Verify `SERVEROUTPUT` is enabled to view log messages.
- Check for database permissions if queries fail.
*/