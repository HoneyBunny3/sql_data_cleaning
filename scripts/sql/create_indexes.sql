/*=============================================================================================
   SQL Script: create_indexes.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script creates indexes on the `contracts` table to improve query performance and ensure 
   data integrity for key operations.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Creates a unique index on the `ROW_KEY` column to enforce data uniqueness.
   ➜ Adds a standard index on the `LGL_NM` column to enhance vendor-based queries.
   ➜ Creates a standard index on the `EFBGN_DT` column to optimize date-based queries.
   ➜ Validates successful index creation by querying the database metadata.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `create_indexes.sql`.
   2️⃣ Open MySQL Workbench or another SQL-compatible environment.
   3️⃣ Execute the script to create indexes on the `contracts` table.
   4️⃣ Verify the indexes using the following query:
       
       SHOW INDEX FROM contracts;

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Add Indexes for Frequently Queried Columns:
       -- Optimize performance for other commonly queried columns:
       
       CREATE INDEX idx_contract_status ON contracts(CONTRACT_STATUS);

   ➤ Automate Index Verification:
       -- Query the database metadata to ensure all indexes exist:
       
       SELECT INDEX_NAME, COLUMN_NAME 
       FROM INFORMATION_SCHEMA.STATISTICS 
       WHERE TABLE_NAME = 'contracts';

   ➤ Log Index Creation:
       -- Create a log table to track the creation of indexes:
       
       CREATE TABLE index_log (
           index_name VARCHAR(100), 
           status VARCHAR(50), 
           created_at DATETIME DEFAULT CURRENT_TIMESTAMP
       );
       INSERT INTO index_log (index_name, status) VALUES ('idx_contracts_row_key', 'Created Successfully');

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `contracts` table exists before running the script.
   ⚙ Verify the user has permissions to create indexes.
   ⚙ Backup the database if necessary before executing the script.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
Boost your database performance by creating optimized indexes for the `contracts` table. 
Streamline queries, ensure data integrity, and elevate system efficiency. Let’s get started!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Step 1: Drop existing indexes if they already exist
DROP INDEX IF EXISTS idx_contracts_row_key ON contracts;
DROP INDEX IF EXISTS idx_contracts_vendor ON contracts;
DROP INDEX IF EXISTS idx_contracts_start_date ON contracts;

-- Step 2: Create a unique index on the `ROW_KEY` column
CREATE UNIQUE INDEX idx_contracts_row_key ON contracts(ROW_KEY);

-- Step 3: Create a standard index on the `LGL_NM` column for vendor queries
CREATE INDEX idx_contracts_vendor ON contracts(LGL_NM);

-- Step 4: Create a standard index on the `EFBGN_DT` column for date-based queries
CREATE INDEX idx_contracts_start_date ON contracts(EFBGN_DT);

-- Step 5: Verify indexes
-- Query the table to confirm that indexes have been created
SHOW INDEX FROM contracts;