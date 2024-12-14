/*=============================================================================================
   SQL Script: nuclear.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script drops all tables in the specified database (`employee_management`) regardless 
   of foreign key constraints. It is designed for scenarios where a complete reset of the 
   database is necessary.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Automatically disables foreign key checks to avoid constraint errors during table drops.
   ➜ Dynamically identifies and drops all tables in the specified database.
   ➜ Ensures foreign key checks are re-enabled after the operation for database integrity.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `nuclear.sql`.
   2️⃣ Open MySQL Workbench or another SQL-compatible environment.
   3️⃣ Execute the script to:
       ➤ Disable foreign key checks.
       ➤ Drop all tables in the `employee_management` database.
       ➤ Re-enable foreign key checks.
   4️⃣ Verify the operation by checking the database for remaining tables:
       
       SELECT table_name 
       FROM information_schema.tables 
       WHERE table_schema = 'employee_management';

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Add Conditional Logic:
       Ensure the script only drops tables in non-critical environments by validating the schema name.

   ➤ Log Dropped Tables:
       -- Create a log table to record which tables were dropped for auditing purposes:
       
       CREATE TABLE drop_log (
           table_name VARCHAR(255),
           dropped_at DATETIME DEFAULT CURRENT_TIMESTAMP
       );

       INSERT INTO drop_log (table_name)
       SELECT table_name 
       FROM information_schema.tables 
       WHERE table_schema = 'employee_management';

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure you have a backup of the database if needed for recovery.
   ⚙ Verify the correct database schema name (`employee_management`) is specified.
   ⚙ Confirm the operation in environments where dropping all tables is permitted.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
This script performs a complete reset of the `employee_management` database by dropping all 
tables. Proceed with caution! Ensure backups are in place before execution.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;

-- Drop all tables in the database
SET @tables = NULL;
SELECT GROUP_CONCAT('`', table_name, '`') INTO @tables
FROM information_schema.tables
WHERE table_schema = 'employee_management';

SET @query = IFNULL(CONCAT('DROP TABLE ', @tables), 'SELECT "No tables found in database."');
PREPARE stmt FROM @query;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;