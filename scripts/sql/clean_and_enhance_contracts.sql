/*=============================================================================================
   SQL Script: clean_and_enhance_contracts.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script performs a comprehensive cleaning and enhancement of the `contracts` table to 
   improve data quality, consistency, and usability for analysis and reporting.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Removes duplicate rows based on `ROW_KEY` for data accuracy.
   ➜ Replaces null and placeholder values in key columns with meaningful defaults.
   ➜ Standardizes text and date fields for uniformity.
   ➜ Normalizes phone numbers and categorizes contracts into logical groups.
   ➜ Adds calculated fields, such as `contract_size` and `contract_duration`, for advanced insights.
   ➜ Identifies potential data issues (`potential_issue`) for further review and resolution.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `clean_and_enhance_contracts.sql`.
   2️⃣ Open MySQL Workbench or another SQL-compatible environment.
   3️⃣ Execute the script to clean and enhance the `contracts` table.
   4️⃣ Verify changes by running validation queries, such as:
       
       SELECT * FROM contracts LIMIT 10;
       SELECT COUNT(*) FROM contracts WHERE potential_issue = TRUE;

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Log Changes for Traceability:
       -- Create an audit table to log the changes applied:
       
       CREATE TABLE contracts_audit (
           log_id INT AUTO_INCREMENT PRIMARY KEY,
           operation VARCHAR(50),
           record_id INT,
           timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
           details TEXT
       );

   ➤ Add Business Rule Validation:
       -- Incorporate custom checks for specific business rules (e.g., spending limits):
       
       INSERT INTO potential_issues (ROW_KEY, issue_details)
       SELECT ROW_KEY, 'Exceeds allowed spending limit'
       FROM contracts
       WHERE MA_PRCH_LMT_AM > MAX_ALLOWED_LIMIT;

   ➤ Generate Reports:
       -- Create summary reports to validate and present the applied enhancements:
       
       SELECT COUNT(*) AS duplicates_removed, COUNT(*) AS null_values_replaced 
       FROM contracts;

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `contracts` table exists and contains data requiring cleaning.
   ⚙ Verify database permissions to alter the `contracts` table (e.g., adding columns).
   ⚙ Backup the table to preserve its current state before running the script.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
Let the cleaning and enhancement process begin! Transform your `contracts` table into a refined 
and reliable dataset, ready for analysis and reporting. Execute confidently and monitor progress!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Step 1: Remove duplicate rows
DELETE FROM contracts
WHERE ROWID NOT IN (
    SELECT MIN(ROWID)
    FROM contracts
    GROUP BY ROW_KEY
);

-- Step 2: Replace null and placeholder values in key columns
UPDATE contracts
SET CONTRACT_SYNOPSIS = 'Not Available'
WHERE CONTRACT_SYNOPSIS IS NULL;

UPDATE contracts
SET ALIAS_NM = 'No Alias'
WHERE ALIAS_NM IS NULL;

UPDATE contracts
SET CONTRACT_CONTACT_NM = 'Unknown'
WHERE CONTRACT_CONTACT_NM IS NULL;

UPDATE contracts
SET CONTRACT_CONTACT_VOICE_PH_NO = 'Unknown'
WHERE CONTRACT_CONTACT_VOICE_PH_NO IS NULL;

UPDATE contracts
SET CONTRACT_CONTACT_EMAIL_AD = 'Unknown'
WHERE CONTRACT_CONTACT_EMAIL_AD IS NULL;

-- Step 3: Standardize text and date fields
UPDATE contracts
SET LGL_NM = UPPER(TRIM(LGL_NM))
WHERE LGL_NM IS NOT NULL;

UPDATE contracts
SET ALIAS_NM = UPPER(TRIM(ALIAS_NM))
WHERE ALIAS_NM IS NOT NULL;

UPDATE contracts
SET CAT_DSCR = UPPER(CAT_DSCR)
WHERE CAT_DSCR IS NOT NULL;

UPDATE contracts
SET EFBGN_DT = '1900-01-01'
WHERE EFBGN_DT IS NULL OR EFBGN_DT < '1900-01-01';

UPDATE contracts
SET EFEND_DT = '1900-01-01'
WHERE EFEND_DT IS NULL OR EFEND_DT < '1900-01-01';

UPDATE contracts
SET BRD_AWD_DT = '1900-01-01'
WHERE BRD_AWD_DT IS NULL OR BRD_AWD_DT < '1900-01-01';

-- Step 4: Normalize phone numbers
UPDATE contracts
SET CONTRACT_CONTACT_VOICE_PH_NO = REGEXP_REPLACE(CONTRACT_CONTACT_VOICE_PH_NO, '[^0-9]', '')
WHERE CONTRACT_CONTACT_VOICE_PH_NO IS NOT NULL;

-- Step 5: Add calculated fields
-- Add "contract_size" to categorize contracts as Minor or Major
ALTER TABLE contracts
ADD COLUMN contract_size VARCHAR(10);

UPDATE contracts
SET contract_size = CASE
    WHEN MA_PRCH_LMT_AM < 100000 THEN 'Minor'
    ELSE 'Major'
END;

-- Add "contract_duration" to calculate duration in days
ALTER TABLE contracts
ADD COLUMN contract_duration INT;

UPDATE contracts
SET contract_duration = DATEDIFF(EFEND_DT, EFBGN_DT);

-- Step 6: Identify potential data issues
-- Add "potential_issue" to flag contracts with spending > 10,000,000
ALTER TABLE contracts
ADD COLUMN potential_issue BOOLEAN;

UPDATE contracts
SET potential_issue = MA_PRCH_LMT_AM > 10000000;