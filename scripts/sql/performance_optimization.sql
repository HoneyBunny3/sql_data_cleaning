/*=============================================================================================
   SQL Script: performance_optimization.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script optimizes database performance by rebuilding indexes and gathering statistics 
   for the `contracts` table. These operations improve query execution speed and overall 
   system performance.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Rebuilds existing indexes on the `contracts` table to enhance query efficiency.
   ➜ Gathers updated table and index statistics to support MySQL's query optimizer.
   ➜ Validates optimization by reviewing index and table statistics.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `performance_optimization.sql`.
   2️⃣ Open MySQL Workbench or another SQL-compatible environment.
   3️⃣ Execute the script during off-peak hours to minimize performance impact.
   4️⃣ Verify the optimization results by:
       ➤ Checking the indexes on the `contracts` table using:
           
           SHOW INDEX FROM contracts;

       ➤ Validating table statistics using:
           
           ANALYZE TABLE contracts;


   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Automate Regular Optimization:
       Use external scheduling tools (e.g., cron jobs) to run this script periodically.

   ➤ Log Optimization Results:
       -- Track index and statistics updates in a custom log table:
       
       CREATE TABLE optimization_log (
           log_id INT AUTO_INCREMENT PRIMARY KEY,
           operation VARCHAR(100),
           start_time DATETIME DEFAULT CURRENT_TIMESTAMP,
           end_time DATETIME,
           status VARCHAR(50)
       );

       INSERT INTO optimization_log (operation, start_time, end_time, status)
       VALUES ('Rebuild Indexes', NOW(), NOW() + INTERVAL 1 MINUTE, 'SUCCESS');

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Verify sufficient database resources to rebuild indexes.
   ⚙ Perform operations during off-peak hours to avoid performance issues.
   ⚙ Backup the database as a precautionary measure before executing this script.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
Maximize the performance of your database! Rebuild indexes, gather statistics, and ensure your 
`contracts` table delivers fast and efficient query results. Execute confidently and monitor logs!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Step 1: Rebuild indexes
-- MySQL does not have a direct "REBUILD INDEX" command, so the workaround is to drop and recreate indexes.

-- Drop existing indexes
DROP INDEX IF EXISTS idx_contracts_row_key ON contracts;
DROP INDEX IF EXISTS idx_contracts_vendor ON contracts;
DROP INDEX IF EXISTS idx_contracts_category ON contracts;
DROP INDEX IF EXISTS idx_contracts_start_date ON contracts;

-- Recreate indexes
CREATE UNIQUE INDEX idx_contracts_row_key ON contracts(ROW_KEY);
CREATE INDEX idx_contracts_vendor ON contracts(LGL_NM);
CREATE INDEX idx_contracts_category ON contracts(CAT_DSCR);
CREATE INDEX idx_contracts_start_date ON contracts(EFBGN_DT);

-- Step 2: Analyze table to gather statistics
-- This helps the query optimizer make better decisions
ANALYZE TABLE contracts;

-- Step 3: Verify index and statistics optimization
-- Check the status of indexes on the `contracts` table
SHOW INDEX FROM contracts;

-- Check table statistics
-- (Statistics are automatically updated by MySQL after `ANALYZE TABLE`, but this is a general verification query)
SELECT table_name, update_time
FROM information_schema.tables
WHERE table_schema = DATABASE() AND table_name = 'contracts';