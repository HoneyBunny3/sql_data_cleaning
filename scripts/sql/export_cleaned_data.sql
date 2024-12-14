/*=============================================================================================
   SQL Script: export_cleaned_data.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script exports cleaned data from the `contracts` table to a CSV file located in the 
   'data/cleaned' directory of the repository. The export includes:
   ➜ A header row with column names for better readability.
   ➜ All cleaned data rows from the `contracts` table.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Exports data in a CSV format with a structured header row.
   ➜ Ensures the exported data reflects the most recent cleaning operations.
   ➜ Verifies the export by checking the record count.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `export_cleaned_data.sql`.
   2️⃣ Open MySQL Workbench or another SQL-compatible environment.
   3️⃣ Ensure the directory `/data/cleaned` exists and has write permissions for the database.
   4️⃣ Grant the database access to write to the directory:
       
       SET GLOBAL local_infile = 1;
       
   5️⃣ Execute the script.
   6️⃣ Verify the CSV file is created at `/data/cleaned/cleaned_data.csv` and contains the expected data.

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Include Filters During Export:
       -- Export only specific rows that meet certain criteria:
       
       SELECT * FROM contracts WHERE contract_status = 'ACTIVE';

   ➤ Log File Metadata:
       -- Create a log entry for each export operation:
       
       CREATE TABLE export_log (
           export_id INT AUTO_INCREMENT PRIMARY KEY,
           file_name VARCHAR(255),
           export_date DATETIME DEFAULT CURRENT_TIMESTAMP,
           record_count INT
       );

       INSERT INTO export_log (file_name, record_count)
       VALUES ('cleaned_data.csv', (SELECT COUNT(*) FROM contracts));

   ➤ Automate Scheduled Exports:
       Use external scheduling tools (e.g., cron jobs) to automate exports at regular intervals.

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `contracts` table contains cleaned data.
   ⚙ Verify the `/data/cleaned` directory exists with the correct permissions.
   ⚙ Grant appropriate privileges to the database user for file operations.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
Export the cleaned `contracts` data to a CSV file for easy sharing and reporting. Ensure all 
prerequisites are met, and execute with confidence. Monitor the logs for progress and results!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Step 1: Export cleaned data to a CSV file
SELECT 'ROW_KEY,CONTRACT_SYNOPSIS,CONTRACT_CONTACT_NM,CONTRACT_CONTACT_VOICE_PH_NO,CONTRACT_CONTACT_EMAIL_AD,MA_PRCH_LMT_AM,MA_ITD_ORD_AM,EFBGN_DT,EFEND_DT,CAT_DSCR,contract_size,contract_duration,potential_issue'
UNION ALL
SELECT 
    ROW_KEY,
    CONTRACT_SYNOPSIS,
    CONTRACT_CONTACT_NM,
    CONTRACT_CONTACT_VOICE_PH_NO,
    CONTRACT_CONTACT_EMAIL_AD,
    MA_PRCH_LMT_AM,
    MA_ITD_ORD_AM,
    EFBGN_DT,
    EFEND_DT,
    CAT_DSCR,
    contract_size,
    contract_duration,
    potential_issue
FROM contracts
INTO OUTFILE '/data/cleaned/cleaned_data.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n';

-- Step 2: Verify the export
-- Check the number of rows exported
SELECT COUNT(*) AS exported_rows
FROM contracts;