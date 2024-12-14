/*=============================================================================================
   SQL Script: data_rollback.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script restores the `contracts` table to its original state by reloading data from 
   the `original_contracts` backup table. It ensures that the table is reverted to a known 
   clean state for consistency and integrity.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Deletes all current data in the `contracts` table to prepare for rollback.
   ➜ Restores original data from the `original_contracts` backup table.
   ➜ Verifies rollback by counting and previewing restored rows.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `data_rollback.sql`.
   2️⃣ Open MySQL Workbench or another SQL-compatible environment.
   3️⃣ Execute the script to:
       ➤ Truncate the `contracts` table.
       ➤ Reload data from the `original_contracts` table.
   4️⃣ Verify the rollback by running validation queries, such as:
       
       SELECT COUNT(*) FROM contracts;
       SELECT * FROM contracts LIMIT 10;

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Create a Timestamped Backup Before Rollback:
       -- Backup the current state of `contracts` before rolling back:
       
       CREATE TABLE contracts_backup AS SELECT * FROM contracts;

   ➤ Add Row-Level Audit Logging:
       -- Track restored records for auditing purposes:
       
       CREATE TABLE rollback_audit (
           record_id INT,
           restored_at DATETIME DEFAULT CURRENT_TIMESTAMP
       );

       INSERT INTO rollback_audit (record_id)
       SELECT ROW_KEY FROM original_contracts;

   ➤ Automate the Rollback Process:
       Use external scheduling tools (e.g., cron jobs) to automate execution when needed.

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `original_contracts` table contains the backup data.
   ⚙ Verify permissions to delete and insert records in the `contracts` table.
   ⚙ Backup the current `contracts` table if needed for future recovery.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
Restore the integrity of your `contracts` table by rolling back to its original state using 
the `original_contracts` backup. Execute with confidence and safeguard your data!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Step 1: Check if `original_contracts` exists
SELECT COUNT(*) AS backup_exists
FROM information_schema.tables
WHERE table_schema = DATABASE() AND table_name = 'original_contracts';

-- Step 2: Truncate the `contracts` table to remove all current data
TRUNCATE TABLE contracts;

-- Step 3: Restore data from the `original_contracts` table
INSERT INTO contracts (
    ROW_KEY,
    DOC_CD,
    DOC_DEPT_CD,
    DOC_ID,
    DOC_VERS_NO,
    DOC_DSCR,
    CONTRACT_SYNOPSIS,
    CONTRACT_CONTACT_NM,
    CONTRACT_CONTACT_VOICE_PH_NO,
    CONTRACT_CONTACT_EMAIL_AD,
    MA_PRCH_LMT_AM,
    MA_ITD_ORD_AM,
    MA_DO_RFED_AM,
    EFBGN_DT,
    EFEND_DT,
    GNRC_PO_RPT_1,
    RPT_DSCR,
    BRD_AWD_DT,
    BRD_AWD_NO,
    CAT_DSCR,
    DOC_VEND_LN_NO,
    VEND_CUST_CD,
    LGL_NM,
    ALIAS_NM,
    SO_DOC_CD,
    SO_DOC_DEPT_CD,
    SO_DOC_ID,
    TODAY
)
SELECT *
FROM original_contracts;

-- Step 4: Verify the rollback
-- Count the number of rows in the restored `contracts` table
SELECT COUNT(*) AS restored_row_count
FROM contracts;

-- Optional: Preview the first few rows
SELECT *
FROM contracts
LIMIT 10;