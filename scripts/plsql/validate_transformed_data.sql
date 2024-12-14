/*=============================================================================================
   PL/SQL Script: validate_transformed_data.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script validates the transformed data in the `contracts` table to ensure accuracy and 
   integrity by performing the following checks:
   ➜ Identifying null values in key columns.
   ➜ Detecting duplicate rows based on the `ROW_KEY` column.
   ➜ Verifying monetary fields have valid (non-negative) values.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Includes error handling for each validation step to ensure robust execution.
   ➜ Logs validation results and errors using `DBMS_OUTPUT.PUT_LINE` for debugging.
   ➜ Summarizes results for easy review and actionable insights.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `validate_transformed_data.sql`.
   2️⃣ Open Oracle SQL Developer (or another PL/SQL-compatible environment).
   3️⃣ Enable server output by running:
       SET SERVEROUTPUT ON;
   4️⃣ Execute the script.
   5️⃣ Review logs to identify:
       ➤ Null values in key columns.
       ➤ Duplicate rows based on `ROW_KEY`.
       ➤ Invalid monetary values.
   6️⃣ Address identified issues in the transformed data before proceeding.

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Add Additional Validation Rules:
       -- Include checks for specific data requirements:
       -- Verify date fields are within expected ranges:
         
         SELECT CONTRACT_DATE FROM contracts WHERE CONTRACT_DATE < TO_DATE('2000-01-01', 'YYYY-MM-DD');
         
       -- Identify malformed email addresses:
         
         SELECT EMAIL FROM contracts WHERE NOT REGEXP_LIKE(EMAIL, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

   ➤ Automate Results Logging:
       -- Store validation results in a log table for auditing:
       
       CREATE TABLE validation_log (
           validation_type VARCHAR2(100),
           details VARCHAR2(4000),
           logged_at DATE DEFAULT SYSDATE
       );

       INSERT INTO validation_log (validation_type, details)
       VALUES ('Null Value Check', 'Column: CONTRACT_SYNOPSIS, Null Count: 15');

   ➤ Generate a Summary Report:
       -- Output a concise summary of validation results for quick review:
       
       BEGIN
           DBMS_OUTPUT.PUT_LINE('Validation Summary:');
           DBMS_OUTPUT.PUT_LINE('Null Values in CONTRACT_SYNOPSIS: 15');
           DBMS_OUTPUT.PUT_LINE('Duplicate ROW_KEY Count: 2');
           DBMS_OUTPUT.PUT_LINE('Negative Monetary Values: 0');
       END;

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `contracts` table contains transformed data ready for validation.
   ⚙ Enable `DBMS_OUTPUT` to monitor validation progress and results.
   ⚙ Backup the `contracts` table if necessary, to preserve the current state.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
Start the validation process! Verify the integrity of your transformed data in the `contracts` 
table to ensure it meets business requirements and is ready for analysis or export.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

BEGIN
    -- Step 1: Check for remaining null values in key columns
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Checking for remaining null values in key columns...');
        FOR rec IN (
            SELECT COLUMN_NAME, COUNT(*) AS null_count
            FROM (
                SELECT 'CONTRACT_SYNOPSIS' AS COLUMN_NAME, CONTRACT_SYNOPSIS AS VALUE FROM contracts
                UNION ALL
                SELECT 'ALIAS_NM', ALIAS_NM FROM contracts
                UNION ALL
                SELECT 'CONTRACT_CONTACT_NM', CONTRACT_CONTACT_NM FROM contracts
                UNION ALL
                SELECT 'CONTRACT_CONTACT_EMAIL_AD', CONTRACT_CONTACT_EMAIL_AD FROM contracts
            )
            WHERE VALUE IS NULL
            GROUP BY COLUMN_NAME
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Column: ' || rec.COLUMN_NAME || ' | Null Values: ' || rec.null_count);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error checking for null values: ' || SQLERRM);
    END;

    -- Step 2: Check for duplicate rows based on ROW_KEY
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Checking for duplicate rows based on ROW_KEY...');
        FOR rec IN (
            SELECT ROW_KEY, COUNT(*) AS duplicate_count
            FROM contracts
            GROUP BY ROW_KEY
            HAVING COUNT(*) > 1
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Duplicate ROW_KEY: ' || rec.ROW_KEY || ' | Count: ' || rec.duplicate_count);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error checking for duplicate rows: ' || SQLERRM);
    END;

    -- Step 3: Verify monetary fields have valid (non-negative) values
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Verifying monetary fields for valid values...');
        FOR rec IN (
            SELECT ROW_KEY, MA_PRCH_LMT_AM, MA_ITD_ORD_AM
            FROM contracts
            WHERE MA_PRCH_LMT_AM < 0 OR MA_ITD_ORD_AM < 0
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Invalid Monetary Value - ROW_KEY: ' || rec.ROW_KEY || 
                                 ' | MA_PRCH_LMT_AM: ' || rec.MA_PRCH_LMT_AM || 
                                 ' | MA_ITD_ORD_AM: ' || rec.MA_ITD_ORD_AM);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error verifying monetary fields: ' || SQLERRM);
    END;

    -- Summary
    DBMS_OUTPUT.PUT_LINE('Validation process completed successfully.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error during validation process: ' || SQLERRM);
END;
/