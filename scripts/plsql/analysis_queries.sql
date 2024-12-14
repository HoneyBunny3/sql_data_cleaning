/*=============================================================================================
   PL/SQL Script: analysis_queries.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script contains advanced analysis queries for the `contracts` table, delivering insights 
   into key business metrics such as:
   ➜ Total spending per category
   ➜ Vendor performance metrics
   ➜ Spending trends over time
   ➜ Contract duration analysis
   ➜ Vendor rankings by spending and contract count

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ✅ Error-handling mechanisms ensure graceful execution.
   ✅ Logs outputs and errors using `DBMS_OUTPUT.PUT_LINE` for debugging and transparency.
   ✅ Enables dynamic query execution, with flexibility for filtering and grouping.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this file as `analysis_queries.sql`.
   2️⃣ Open Oracle SQL Developer (or another PL/SQL-compatible environment).
   3️⃣ Enable server output by running:
       SET SERVEROUTPUT ON;
   4️⃣ Execute the script.
   5️⃣ Review logs in the output console for query results or any error messages.

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Tailor query filters for specific business needs.
   ➤ Export query results to a table or CSV file for further analysis.
   ➤ Incorporate advanced ranking/grouping logic for more detailed insights.

   ⚠️ Troubleshooting:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `contracts` table contains cleaned and validated data.
   ⚙ Verify `SERVEROUTPUT` is enabled to log outputs and errors.
   ⚙ Check database permissions if queries fail unexpectedly.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
The main script starts here. Prepare to analyze, debug, and generate insights with precision. 
Ensure all prerequisites are met before execution. Happy querying!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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