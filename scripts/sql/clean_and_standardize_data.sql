/*=============================================================================================
   SQL Script: clean_and_standardize_data.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script cleans and standardizes data in the `contracts` table to improve accuracy, 
   consistency, and usability for downstream processes and reporting.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Removes duplicate rows based on the `ROW_KEY` column for data integrity.
   ➜ Handles null and unknown values in key fields by replacing them with appropriate defaults.
   ➜ Standardizes date formats and resolves invalid date entries.
   ➜ Replaces negative monetary values with 0 for logical consistency.
   ➜ Normalizes text fields and phone numbers for uniformity.
   ➜ Ensures category descriptions are standardized for easier analysis.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `clean_and_standardize_data.sql`.
   2️⃣ Open MySQL Workbench or another SQL-compatible environment.
   3️⃣ Execute the script to clean and standardize the `contracts` table.
   4️⃣ Verify changes using queries such as:
       
       SELECT * FROM contracts LIMIT 10;
       SELECT COUNT(*) AS duplicates_removed FROM contracts WHERE ROWID NOT IN (
           SELECT MIN(ROWID) FROM contracts GROUP BY ROW_KEY
       );

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Add Additional Data Validation:
       -- Run queries to check for specific anomalies after cleaning:
       
       SELECT COUNT(*) AS invalid_dates FROM contracts WHERE EFBGN_DT < '2000-01-01';

   ➤ Create Summary Reports:
       -- Generate summary reports to validate and review changes:
       
       SELECT 
           COUNT(*) AS total_rows, 
           COUNT(DISTINCT ROW_KEY) AS unique_rows, 
           COUNT(*) - COUNT(DISTINCT ROW_KEY) AS duplicates_removed 
       FROM contracts;

   ➤ Log Results into an Audit Table:
       -- Create a log table to track details of cleaning operations:
       
       CREATE TABLE data_cleaning_audit (
           log_id INT AUTO_INCREMENT PRIMARY KEY,
           action VARCHAR(100),
           affected_rows INT,
           timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
           details TEXT
       );

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `contracts` table is backed up before execution.
   ⚙ Verify the user has permissions to alter the `contracts` table.
   ⚙ Backup the current state of the database if required.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
The cleaning and standardization process begins here! Transform your `contracts` table into a 
reliable and consistent dataset, ready for analysis and reporting. Execute with confidence!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Step 1: Remove duplicate rows
DELETE FROM contracts
WHERE ROWID NOT IN (
    SELECT MIN(ROWID)
    FROM contracts
    GROUP BY ROW_KEY
);

-- Step 2: Handle null or unknown values in key fields
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

-- Step 3: Standardize date formats and replace invalid dates
UPDATE contracts
SET EFBGN_DT = '1900-01-01'
WHERE EFBGN_DT IS NULL OR EFBGN_DT < '1900-01-01';

UPDATE contracts
SET EFEND_DT = '1900-01-01'
WHERE EFEND_DT IS NULL OR EFEND_DT < '1900-01-01';

UPDATE contracts
SET BRD_AWD_DT = '1900-01-01'
WHERE BRD_AWD_DT IS NULL OR BRD_AWD_DT < '1900-01-01';

-- Step 4: Replace negative monetary values with 0
UPDATE contracts
SET MA_PRCH_LMT_AM = 0
WHERE MA_PRCH_LMT_AM < 0;

UPDATE contracts
SET MA_ITD_ORD_AM = 0
WHERE MA_ITD_ORD_AM < 0;

UPDATE contracts
SET MA_DO_RFED_AM = 0
WHERE MA_DO_RFED_AM < 0;

-- Step 5: Normalize text fields and phone numbers
UPDATE contracts
SET LGL_NM = UPPER(TRIM(LGL_NM))
WHERE LGL_NM IS NOT NULL;

UPDATE contracts
SET ALIAS_NM = UPPER(TRIM(ALIAS_NM))
WHERE ALIAS_NM IS NOT NULL;

UPDATE contracts
SET CONTRACT_CONTACT_VOICE_PH_NO = REGEXP_REPLACE(CONTRACT_CONTACT_VOICE_PH_NO, '[^0-9]', '')
WHERE CONTRACT_CONTACT_VOICE_PH_NO IS NOT NULL;

-- Step 6: Normalize category descriptions
UPDATE contracts
SET CAT_DSCR = UPPER(CAT_DSCR)
WHERE CAT_DSCR IS NOT NULL;