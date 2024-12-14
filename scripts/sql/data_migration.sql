/*=============================================================================================
   SQL Script: data_migration.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script migrates data from a staging table (`staging_contracts`) to the production 
   `contracts` table while ensuring no duplicate entries are introduced.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Ensures only new records are migrated by using a `NOT EXISTS` check to prevent duplicates.
   ➜ Transfers data seamlessly from staging to production while maintaining data integrity.
   ➜ Verifies migration results with validation queries to confirm success.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `data_migration.sql`.
   2️⃣ Open MySQL Workbench or another SQL-compatible environment.
   3️⃣ Execute the script to migrate data from `staging_contracts` to `contracts`.
   4️⃣ Verify the migration by running validation queries, such as:
       
       SELECT COUNT(*) FROM contracts;
       SELECT COUNT(*) 
       FROM staging_contracts AS s 
       WHERE NOT EXISTS (
           SELECT 1 
           FROM contracts AS c 
           WHERE c.ROW_KEY = s.ROW_KEY
       );

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Add Audit Logging:
       -- Track migrated records for auditing purposes:
       
       CREATE TABLE migration_audit (
           migration_id INT AUTO_INCREMENT PRIMARY KEY,
           record_id INT,
           migrated_at DATETIME DEFAULT CURRENT_TIMESTAMP
       );

       INSERT INTO migration_audit (record_id)
       SELECT ROW_KEY 
       FROM staging_contracts AS s
       WHERE NOT EXISTS (
           SELECT 1 
           FROM contracts AS c 
           WHERE c.ROW_KEY = s.ROW_KEY
       );

   ➤ Validate Data Before Migration:
        -- Check for anomalies in the staging data before migrating:
       
       SELECT * FROM staging_contracts 
       WHERE EFBGN_DT IS NULL OR LGL_NM IS NULL;

   ➤ Automate the Migration Process:
       Use external scheduling tools (e.g., cron jobs) to automate regular updates.

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `staging_contracts` table is populated and matches the structure of the 
      `contracts` table.
   ⚙ Verify database permissions to insert records into the `contracts` table.
   ⚙ Backup the database if necessary before running the script.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
Start the migration process! Seamlessly transfer new records from `staging_contracts` to 
`contracts` while ensuring data integrity and eliminating duplicates. Execute confidently!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Step 1: Insert new records from `staging_contracts` to `contracts`
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
SELECT 
    s.ROW_KEY,
    s.DOC_CD,
    s.DOC_DEPT_CD,
    s.DOC_ID,
    s.DOC_VERS_NO,
    s.DOC_DSCR,
    s.CONTRACT_SYNOPSIS,
    s.CONTRACT_CONTACT_NM,
    s.CONTRACT_CONTACT_VOICE_PH_NO,
    s.CONTRACT_CONTACT_EMAIL_AD,
    s.MA_PRCH_LMT_AM,
    s.MA_ITD_ORD_AM,
    s.MA_DO_RFED_AM,
    s.EFBGN_DT,
    s.EFEND_DT,
    s.GNRC_PO_RPT_1,
    s.RPT_DSCR,
    s.BRD_AWD_DT,
    s.BRD_AWD_NO,
    s.CAT_DSCR,
    s.DOC_VEND_LN_NO,
    s.VEND_CUST_CD,
    s.LGL_NM,
    s.ALIAS_NM,
    s.SO_DOC_CD,
    s.SO_DOC_DEPT_CD,
    s.SO_DOC_ID,
    s.TODAY
FROM staging_contracts AS s
WHERE NOT EXISTS (
    SELECT 1 
    FROM contracts AS c 
    WHERE c.ROW_KEY = s.ROW_KEY
);

-- Step 2: Verify migration results
-- Count the number of records in the `contracts` table after migration
SELECT COUNT(*) AS total_records_in_contracts
FROM contracts;

-- Count the number of records migrated from `staging_contracts`
SELECT COUNT(*) AS migrated_records
FROM staging_contracts AS s
WHERE NOT EXISTS (
    SELECT 1 
    FROM contracts AS c 
    WHERE c.ROW_KEY = s.ROW_KEY
);