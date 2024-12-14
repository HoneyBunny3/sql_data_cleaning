/*=============================================================================================
   SQL Script: test_cleaning.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script validates the cleaned data in the `contracts` table to ensure data accuracy and 
   integrity by performing the following checks:
   ➜ Detecting duplicate records based on key fields.
   ➜ Checking for NULL values in mandatory fields.
   ➜ Validating date ranges and logical field constraints (e.g., `start_date` < `end_date`).
   ➜ Identifying negative contract values and invalid field formats.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Performs comprehensive validation to detect data anomalies.
   ➜ Summarizes findings for quick review and actionable insights.
   ➜ Ensures the `contracts` table meets business and data quality requirements.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `test_cleaning.sql`.
   2️⃣ Open MySQL Workbench or another SQL-compatible environment.
   3️⃣ Execute the script to validate the data in the `contracts` table.
   4️⃣ Review the validation results by examining query outputs, such as:
       ➤ Duplicate records.
       ➤ NULL values in mandatory fields.
       ➤ Logical inconsistencies in field values.
       ➤ Invalid data formats.

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Add Additional Validation Rules:
       -- Check for specific data anomalies, such as:
       - Date ranges:
         
         SELECT * FROM contracts WHERE start_date > end_date;

       - Invalid email formats:
         
         SELECT contract_contact_email_ad 
         FROM contracts 
         WHERE contract_contact_email_ad NOT LIKE '%@%.%';

   ➤ Log Validation Results:
       -- Create a log table to store validation outcomes for auditing:
       
       CREATE TABLE validation_log (
           validation_step VARCHAR(100),
           details VARCHAR(400),
           logged_at DATETIME DEFAULT CURRENT_TIMESTAMP
       );

       INSERT INTO validation_log (validation_step, details)
       VALUES ('NULL Value Check', 'Null values found in employee_id: 5 records');

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `contracts` table contains cleaned data ready for validation.
   ⚙ Backup the `contracts` table if needed to preserve its current state.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
Start the validation process! Verify the integrity of your cleaned data in the `contracts` 
table to ensure it meets business requirements and is ready for analysis or export.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Test 1: Check for duplicates
SELECT 'Duplicate Records Check' AS validation_step,
       employee_id,
       start_date,
       end_date,
       COUNT(*) AS duplicate_count
FROM contracts
GROUP BY employee_id, start_date, end_date
HAVING COUNT(*) > 1;

-- Test 2: Check for NULL values in mandatory fields
SELECT 'NULL Values Check' AS validation_step,
       contract_id,
       employee_id,
       employee_name,
       start_date,
       end_date
FROM contracts
WHERE employee_id IS NULL
   OR employee_name IS NULL
   OR start_date IS NULL
   OR end_date IS NULL;

-- Test 3: Validate date ranges (start_date < end_date)
SELECT 'Date Range Validation' AS validation_step,
       contract_id,
       start_date,
       end_date
FROM contracts
WHERE start_date >= end_date;

-- Test 4: Check for negative contract values
SELECT 'Negative Contract Value Check' AS validation_step,
       contract_id,
       contract_value
FROM contracts
WHERE contract_value < 0;

-- Test 5: Validate field formats (e.g., date format, text capitalization)
SELECT 'Field Format Validation' AS validation_step,
       contract_id,
       employee_name,
       start_date
FROM contracts
WHERE employee_name REGEXP '[^A-Za-z ]' -- Employee name contains invalid characters
   OR start_date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'; -- Start date not in YYYY-MM-DD format;

-- Summary of validation results
SELECT 'Validation Summary' AS validation_step,
       (SELECT COUNT(*) FROM contracts WHERE employee_id IS NULL) AS null_employee_count,
       (SELECT COUNT(*) FROM contracts WHERE start_date >= end_date) AS invalid_date_ranges,
       (SELECT COUNT(*) FROM contracts WHERE contract_value < 0) AS negative_values,
       (SELECT COUNT(*) FROM (
           SELECT employee_id, start_date, end_date
           FROM contracts
           GROUP BY employee_id, start_date, end_date
           HAVING COUNT(*) > 1
       ) AS duplicates) AS duplicate_count;