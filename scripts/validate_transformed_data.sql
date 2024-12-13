/*
PL/SQL Script: validate_transformed_data.sql
-------------------------------------------
Purpose:
This script validates the transformed data in the `contracts` table by:
1. Checking for remaining null values in key columns.
2. Identifying duplicate rows based on the `ROW_KEY` column.
3. Verifying that monetary fields have valid (non-negative) values.

Features:
1. Error handling for each validation step to ensure robust execution.
2. Uses `DBMS_OUTPUT.PUT_LINE` to log results and errors for debugging.
3. Summarizes validation results for easy review.

Execution Notes:
- Ensure the `contracts` table contains transformed data before running this script.
- Enable `SERVEROUTPUT` in your environment to display logs.
*/

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

/*
Execution Instructions:
-------------------------------------------
1. Save this script as `validate_transformed_data.sql`.
2. Open Oracle SQL Developer or another PL/SQL-compatible environment.
3. Enable `DBMS_OUTPUT` by running:
   SET SERVEROUTPUT ON;
4. Execute the script.
5. Review the logs to identify:
   - Null values in key columns.
   - Duplicate rows based on ROW_KEY.
   - Invalid monetary values.
6. Address any identified issues in the transformed data.
-------------------------------------------

Optional Enhancements:
-------------------------------------------
1. Add Checks for Additional Validation Rules:
   - Verify date fields are within expected ranges.
   - Identify invalid or malformed email addresses.

2. Automate Results Logging:
   - Create a log table to store validation results for auditing purposes:
     CREATE TABLE validation_log (
         validation_type VARCHAR2(100),
         details VARCHAR2(4000),
         logged_at DATE DEFAULT SYSDATE
     );
     INSERT INTO validation_log (validation_type, details)
     VALUES ('Null Value Check', 'Column: CONTRACT_SYNOPSIS, Null Count: 15');

3. Generate a Summary Report:
   - Extend the script to output a concise summary of validation results for quick review.
*/