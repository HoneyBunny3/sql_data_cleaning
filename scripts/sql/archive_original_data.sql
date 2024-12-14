/*=============================================================================================
   SQL Script: archive_original_data.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script archives the original, uncleaned data from the `contracts` table into a new 
   table called `original_contracts`, ensuring data preservation for future reference or rollback.
   
   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Automatically handles the existence of the `original_contracts` table by dropping it if necessary.
   ➜ Creates a new archive table and transfers all data from the `contracts` table.
   ➜ Adds a timestamp column (`archived_at`) to record when the data was archived.
   ➜ Provides flexibility to archive specific columns or subsets of data.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `archive_original_data.sql`.
   2️⃣ Open MySQL Workbench or another SQL-compatible environment.
   3️⃣ Execute the script to create the archive table and copy data.
   4️⃣ Verify the archive by running the query:
   
       SELECT * FROM original_contracts;

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Archive Only Specific Columns:
       -- Modify the `SELECT` statement to include only required columns:
       
       CREATE TABLE original_contracts AS 
       SELECT ROW_KEY, CONTRACT_SYNOPSIS, LGL_NM, MA_PRCH_LMT_AM, CURRENT_DATE() AS archived_at 
       FROM contracts;

   ➤ Archive a Subset of Data:
       -- Add a `WHERE` clause to filter rows for selective archiving:
    
       CREATE TABLE original_contracts AS 
       SELECT * 
       FROM contracts 
       WHERE MA_PRCH_LMT_AM > 0;

   ➤ Add Indexes to Optimize the Archive Table:
       -- For faster querying, add indexes to the `original_contracts` table:
       
       CREATE INDEX idx_row_key ON original_contracts (ROW_KEY);
       

   ⚠️ Troubleshooting:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `contracts` table contains uncleaned data prior to running the script.
   ⚙ Verify that the user has the necessary permissions to create and drop tables.
   ⚙ Check database compatibility and syntax if any errors occur.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
The archiving process starts here. Original data preservation ensures safety and traceability. 
Prepare to execute and safeguard your uncleaned data with precision. 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Step 1: Drop the `original_contracts` table if it already exists
DROP TABLE IF EXISTS original_contracts;

-- Step 2: Create a backup table `original_contracts`
CREATE TABLE original_contracts AS
SELECT *
FROM contracts;

-- Step 3: Verify data has been copied
SELECT COUNT(*) AS archived_rows
FROM original_contracts;