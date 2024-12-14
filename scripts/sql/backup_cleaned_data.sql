/*=============================================================================================
   SQL Script: backup_cleaned_data.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script creates a reliable backup of the cleaned data from the `contracts` table to 
   ensure data preservation, integrity, and accessibility for future reference.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Creates a backup table (`cleaned_contracts`) to store a snapshot of the cleaned data.
   ➜ Adds a primary key and indexes to ensure data integrity and optimize query performance.
   ➜ Ensures the backup is accurate by verifying record counts and previewing sample rows.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `backup_cleaned_data.sql`.
   2️⃣ Open MySQL Workbench or another SQL-compatible environment.
   3️⃣ Execute the script to:
       ➤ Create the `cleaned_contracts` table.
       ➤ Add necessary indexes to optimize query performance.
       ➤ Verify the backup using row counts and sample previews.
   4️⃣ Review the backup by running:
       
       SELECT COUNT(*) FROM cleaned_contracts;
       SELECT * FROM cleaned_contracts LIMIT 10;

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Add Additional Indexes:
       -- Optimize performance for other frequently queried columns:
       
       CREATE INDEX idx_cleaned_contracts_status ON cleaned_contracts(CONTRACT_STATUS);

   ➤ Archive Specific Columns or Rows:
       -- Customize the backup to include only relevant data:
       
       CREATE TABLE cleaned_contracts AS 
       SELECT ROW_KEY, LGL_NM, MA_PRCH_LMT_AM 
       FROM contracts 
       WHERE MA_PRCH_LMT_AM > 0;

   ➤ Add Timestamp for Backup Tracking:
       -- Include a timestamp column in the backup table for tracking:
       
       CREATE TABLE cleaned_contracts AS 
       SELECT *, CURRENT_DATE() AS archived_at 
       FROM contracts;

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `contracts` table contains cleaned data before executing this script.
   ⚙ Verify the user has permissions to create tables and indexes.
   ⚙ Backup the database if needed to preserve its current state.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
The backup process begins here. Safeguard your cleaned data with this automated solution, 
ensuring reliability, integrity, and accessibility for future use. Execute confidently!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Step 1: Drop the `cleaned_contracts` table if it already exists
DROP TABLE IF EXISTS cleaned_contracts;

-- Step 2: Create a backup table `cleaned_contracts` from the `contracts` table
CREATE TABLE cleaned_contracts AS
SELECT *
FROM contracts;

-- Step 3: Add a primary key to the backup table
ALTER TABLE cleaned_contracts
ADD PRIMARY KEY (ROW_KEY);

-- Step 4: Add indexes for optimized queries
CREATE INDEX idx_cleaned_contracts_vendor ON cleaned_contracts(LGL_NM);
CREATE INDEX idx_cleaned_contracts_category ON cleaned_contracts(CAT_DSCR);
CREATE INDEX idx_cleaned_contracts_date ON cleaned_contracts(EFBGN_DT);

-- Step 5: Verify the backup
-- Check the row count
SELECT COUNT(*) AS row_count
FROM cleaned_contracts;

-- Preview sample rows
SELECT *
FROM cleaned_contracts
LIMIT 10;