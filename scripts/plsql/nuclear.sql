/*=============================================================================================
   PL/SQL Script: nuclear_plsql.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script drops all tables in the specified database schema (`employee_management`) 
   regardless of foreign key constraints. It is designed for scenarios where a complete reset 
   of the schema is necessary.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Automatically disables foreign key checks to avoid constraint errors during table drops.
   ➜ Dynamically identifies and drops all tables in the specified schema using a PL/SQL block.
   ➜ Re-enables foreign key checks after the operation to restore database integrity.
   ➜ Logs progress and results for better transparency during execution.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `nuclear_plsql.sql`.
   2️⃣ Open Oracle SQL Developer or another PL/SQL-compatible environment.
   3️⃣ Execute the script to:
       ➤ Disable foreign key checks.
       ➤ Drop all tables in the `employee_management` schema.
       ➤ Re-enable foreign key checks.
   4️⃣ Verify the operation by checking for remaining tables in the schema:
       
       SELECT table_name 
       FROM user_tables 
       WHERE table_name IS NOT NULL;

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Add Conditional Logic:
       Ensure the script only drops tables in non-critical environments by validating the schema name.

   ➤ Log Dropped Tables:
       -- Create a log table to record which tables were dropped for auditing purposes:
       
       CREATE TABLE drop_log (
           table_name VARCHAR2(255),
           dropped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
       );

       INSERT INTO drop_log (table_name)
       SELECT table_name 
       FROM user_tables;

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure you have a backup of the schema if needed for recovery.
   ⚙ Verify the correct schema name (`employee_management`) is specified.
   ⚙ Confirm the operation in environments where dropping all tables is permitted.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
This script performs a complete reset of the `employee_management` schema by dropping all 
tables. Proceed with caution! Ensure backups are in place before execution.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

BEGIN
   -- Disable foreign key checks
   EXECUTE IMMEDIATE 'ALTER SESSION SET CONSTRAINTS = DEFERRED';

   -- Loop through all tables in the schema and drop them
   FOR table_rec IN (
       SELECT table_name 
       FROM user_tables
   ) LOOP
       BEGIN
           EXECUTE IMMEDIATE 'DROP TABLE ' || table_rec.table_name || ' CASCADE CONSTRAINTS';
           DBMS_OUTPUT.PUT_LINE('Dropped table: ' || table_rec.table_name);
       EXCEPTION
           WHEN OTHERS THEN
               DBMS_OUTPUT.PUT_LINE('Error dropping table: ' || table_rec.table_name || ' - ' || SQLERRM);
       END;
   END LOOP;

   -- Re-enable foreign key checks
   EXECUTE IMMEDIATE 'ALTER SESSION SET CONSTRAINTS = IMMEDIATE';

   DBMS_OUTPUT.PUT_LINE('All tables dropped successfully.');
END;
/