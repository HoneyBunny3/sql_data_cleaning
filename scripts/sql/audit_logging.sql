/*=============================================================================================
   SQL Script: audit_logging.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script logs changes made to the `contracts` table into an audit table (`audit_log`) 
   to ensure traceability and compliance with data management policies.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Captures key details of changes, including the action performed, table name, timestamp, 
      and specifics of the modification.
   ➜ Automatically creates the `audit_log` table if it does not exist.
   ➜ Provides sample entries to track updates and changes for compliance.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `audit_logging.sql`.
   2️⃣ Open MySQL Workbench or another SQL-compatible environment.
   3️⃣ Execute the script to create the `audit_log` table and insert sample entries.
   4️⃣ Verify log entries in the `audit_log` table by running the following query:
   
       SELECT * FROM audit_log;

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the user has permissions to create and insert into the `audit_log` table.
   ⚙ Verify database compatibility and syntax before running the script.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
The audit logging process starts here. Capture and preserve change details with precision 
to maintain compliance and traceability. Execute confidently! 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

-- Step 1: Create the `audit_log` table if it does not exist
CREATE TABLE IF NOT EXISTS audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    action VARCHAR(255) NOT NULL,
    table_name VARCHAR(255) NOT NULL,
    change_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    details TEXT
);

-- Step 2: Insert a log entry for an action performed on the `contracts` table
INSERT INTO audit_log (action, table_name, details)
VALUES ('Data Cleaning', 'contracts', 'Removed duplicates and standardized key fields.');

-- Example Log Entry for Updating a Field
-- INSERT INTO audit_log (action, table_name, details)
-- VALUES ('Update Field', 'contracts', 'Updated CONTRACT_SYNOPSIS with default values for NULL entries.');

-- Step 3: Query the audit log to verify entries
SELECT * FROM audit_log
ORDER BY change_timestamp DESC;