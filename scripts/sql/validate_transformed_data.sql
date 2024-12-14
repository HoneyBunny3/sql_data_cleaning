/*=============================================================================================
   SQL Script: validate_transformed_data.sql
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
   ➜ Performs comprehensive validation to detect data anomalies.
   ➜ Summarizes validation results for quick review and actionable insights.
   ➜ Ensures the `contracts` table meets business and data quality requirements.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `validate_transformed_data.sql`.
   2️⃣ Open MySQL Workbench or another SQL-compatible environment.
   3️⃣ Execute the script to validate the data in the `contracts` table.
   4️⃣ Review the validation results by examining query outputs, such as:
       ➤ Null value counts for mandatory columns.
       ➤ Duplicate row counts based on `ROW_KEY`.
       ➤ Count of invalid monetary values.

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Add Additional Validation Rules:
       -- Check for specific data anomalies, such as:
       - Date ranges:
         
         SELECT EFBGN_DT FROM contracts WHERE EFBGN_DT < '2000-01-01';

       - Email format validation:
         
         SELECT CONTRACT_CONTACT_EMAIL_AD 
         FROM contracts 
         WHERE CONTRACT_CONTACT_EMAIL_AD NOT LIKE '%@%.%';

   ➤ Automate Results Logging:
       -- Store validation results in a log table for auditing:
       
       CREATE TABLE validation_log (
           validation_step VARCHAR(100),
           details VARCHAR(400),
           logged_at DATETIME DEFAULT CURRENT_TIMESTAMP
       );

       INSERT INTO validation_log (validation_step, details)
       VALUES ('Null Value Check', 'CONTRACT_SYNOPSIS null count: 15');

   ➤ Generate a Comprehensive Summary Report:
       -- Create a summary table or output with all validation metrics:
       
       SELECT 
           (SELECT COUNT(*) FROM contracts WHERE CONTRACT_SYNOPSIS IS NULL) AS null_synopsis_count,
           (SELECT COUNT(*) FROM contracts WHERE ROW_KEY IS NULL) AS null_row_key_count,
           (SELECT COUNT(*) FROM contracts WHERE MA_PRCH_LMT_AM < 0) AS negative_prch_limit_count;

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `contracts` table contains transformed data ready for validation.
   ⚙ Backup the `contracts` table if needed to preserve its current state.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
Start the validation process! Verify the integrity of your transformed data in the `contracts` 
table to ensure it meets business requirements and is ready for analysis or export.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Step 1: Check for null values in mandatory columns
SELECT 'Null Value Check' AS validation_step, COLUMN_NAME, COUNT(*) AS null_count
FROM (
    SELECT 'CONTRACT_SYNOPSIS' AS COLUMN_NAME FROM contracts WHERE CONTRACT_SYNOPSIS IS NULL
    UNION ALL
    SELECT 'ALIAS_NM' AS COLUMN_NAME FROM contracts WHERE ALIAS_NM IS NULL
    UNION ALL
    SELECT 'CONTRACT_CONTACT_NM' AS COLUMN_NAME FROM contracts WHERE CONTRACT_CONTACT_NM IS NULL
    UNION ALL
    SELECT 'CONTRACT_CONTACT_VOICE_PH_NO' AS COLUMN_NAME FROM contracts WHERE CONTRACT_CONTACT_VOICE_PH_NO IS NULL
    UNION ALL
    SELECT 'CONTRACT_CONTACT_EMAIL_AD' AS COLUMN_NAME FROM contracts WHERE CONTRACT_CONTACT_EMAIL_AD IS NULL
    UNION ALL
    SELECT 'EFBGN_DT' AS COLUMN_NAME FROM contracts WHERE EFBGN_DT IS NULL
    UNION ALL
    SELECT 'EFEND_DT' AS COLUMN_NAME FROM contracts WHERE EFEND_DT IS NULL
) AS null_checks
GROUP BY COLUMN_NAME;

-- Step 2: Check for duplicate rows based on ROW_KEY
SELECT 'Duplicate Row Check' AS validation_step, ROW_KEY, COUNT(*) AS duplicate_count
FROM contracts
GROUP BY ROW_KEY
HAVING COUNT(*) > 1;

-- Step 3: Verify monetary fields have valid (non-negative) values
SELECT 'Negative Monetary Value Check' AS validation_step, COLUMN_NAME, COUNT(*) AS invalid_count
FROM (
    SELECT 'MA_PRCH_LMT_AM' AS COLUMN_NAME FROM contracts WHERE MA_PRCH_LMT_AM < 0
    UNION ALL
    SELECT 'MA_ITD_ORD_AM' AS COLUMN_NAME FROM contracts WHERE MA_ITD_ORD_AM < 0
    UNION ALL
    SELECT 'MA_DO_RFED_AM' AS COLUMN_NAME FROM contracts WHERE MA_DO_RFED_AM < 0
) AS monetary_checks
GROUP BY COLUMN_NAME;

-- Step 4: Summary of validation results
SELECT 
    'Validation Summary' AS validation_step,
    (SELECT COUNT(*) FROM contracts WHERE CONTRACT_SYNOPSIS IS NULL) AS null_synopsis_count,
    (SELECT COUNT(*) FROM contracts WHERE ALIAS_NM IS NULL) AS null_alias_count,
    (SELECT COUNT(*) FROM contracts WHERE ROW_KEY IS NULL) AS null_row_key_count,
    (SELECT COUNT(*) FROM (
        SELECT ROW_KEY FROM contracts GROUP BY ROW_KEY HAVING COUNT(*) > 1
    ) AS duplicates) AS duplicate_row_count,
    (SELECT COUNT(*) FROM contracts WHERE MA_PRCH_LMT_AM < 0) AS negative_prch_limit_count,
    (SELECT COUNT(*) FROM contracts WHERE MA_ITD_ORD_AM < 0) AS negative_ord_amount_count;