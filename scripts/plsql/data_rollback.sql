/*=============================================================================================
   PL/SQL Script: data_rollback.sql
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
   ➜ Includes error handling to ensure robust execution and to provide meaningful feedback.
   ➜ Logs progress, errors, and completion details using `DBMS_OUTPUT.PUT_LINE`.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `data_rollback.sql`.
   2️⃣ Open Oracle SQL Developer (or another PL/SQL-compatible environment).
   3️⃣ Enable server output by running:
       SET SERVEROUTPUT ON;
   4️⃣ Execute the script.
   5️⃣ Verify the restoration by:
       ➤ Checking the total record count in the `contracts` table:
           
           SELECT COUNT(*) FROM contracts;

       ➤ Reviewing the restored data with validation queries.

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Create a Timestamped Backup Before Rollback:
       -- Backup the current state of `contracts` before rolling back:
       
       CREATE TABLE contracts_backup AS SELECT * FROM contracts;

   ➤ Add Row-Level Audit Logging:
       -- Track restored records for auditing purposes:
       
       CREATE TABLE rollback_audit (
           record_id NUMBER,
           restored_at TIMESTAMP DEFAULT SYSDATE
       );
       INSERT INTO rollback_audit (record_id)
       SELECT ROW_KEY FROM original_contracts;

   ➤ Automate the Rollback Process:
       -- Schedule the rollback script for automated execution if needed:
       
       BEGIN
           DBMS_SCHEDULER.CREATE_JOB (
               job_name        => 'data_rollback_job',
               job_type        => 'PLSQL_BLOCK',
               job_action      => 'BEGIN EXECUTE IMMEDIATE ''@data_rollback.sql''; END;',
               start_date      => SYSTIMESTAMP,
               enabled         => TRUE
           );
       END;

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

BEGIN
    -- Log the start of the rollback process
    DBMS_OUTPUT.PUT_LINE('Starting data rollback process...');

    -- Clear the `contracts` table
    BEGIN
        DELETE FROM contracts;
        DBMS_OUTPUT.PUT_LINE('Existing data in contracts table cleared.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error clearing contracts table: ' || SQLERRM);
    END;

    -- Restore data from the `original_contracts` table
    BEGIN
        INSERT INTO contracts SELECT * FROM original_contracts;
        DBMS_OUTPUT.PUT_LINE('Data restored from original_contracts table.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error restoring data from original_contracts: ' || SQLERRM);
    END;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error during the data rollback process: ' || SQLERRM);
END;
/