/*=============================================================================================
   PL/SQL Script: archive_original_data.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script archives the original, uncleaned data from the `contracts` table into a new 
   table called `original_contracts`, ensuring data preservation for future reference or rollback.
   
   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Automatically handles the existence of the `original_contracts` table by dropping it if necessary.
   ➜ Creates a new archive table and transfers all data from the `contracts` table.
   ➜ Adds a timestamp (`archived_at`) to record when each row was archived.
   ➜ Provides flexibility to archive specific columns or subsets of data.
   ➜ Uses `DBMS_OUTPUT.PUT_LINE` to log errors and feedback for debugging.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `archive_original_data.sql`.
   2️⃣ Open Oracle SQL Developer (or another PL/SQL-compatible environment).
   3️⃣ Enable server output by running:
       SET SERVEROUTPUT ON;
   4️⃣ Execute the script.
   5️⃣ Verify the archive by running the query:
       SELECT * FROM original_contracts;

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Archive Only Specific Columns:
       Modify the `SELECT` statement to include only required columns:
       
       SELECT ROW_KEY, CONTRACT_SYNOPSIS, LGL_NM, MA_PRCH_LMT_AM, SYSDATE AS archived_at 
       FROM contracts;
       
   ➤ Archive a Subset of Data:
       -- Add a `WHERE` clause to filter rows for selective archiving:
       
       SELECT * 
       FROM contracts 
       WHERE MA_PRCH_LMT_AM > 0;
       
   ➤ Add Indexes to Optimize the Archive Table:
       -- For faster querying, add indexes to the `original_contracts` table:
       
       EXECUTE IMMEDIATE 'CREATE INDEX idx_row_key ON original_contracts (ROW_KEY)';

   ⚠️ Troubleshooting:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `contracts` table contains uncleaned data prior to running the script.
   ⚙ Verify that `SET SERVEROUTPUT ON` is enabled to log execution feedback.
   ⚙ Check database permissions to ensure the script can create and drop tables.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
The archiving process starts here. Original data preservation ensures safety and traceability. 
Prepare to execute and safeguard your uncleaned data with precision. 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

BEGIN
    -- Step 1: Check if the table exists and drop it
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE original_contracts';
        DBMS_OUTPUT.PUT_LINE('Existing table original_contracts dropped successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE != -942 THEN -- ORA-00942: Table does not exist
                RAISE;
            ELSE
                DBMS_OUTPUT.PUT_LINE('Table original_contracts does not exist. Proceeding to create it.');
            END IF;
    END;

    -- Step 2: Create the archive table and copy data
    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE original_contracts AS 
                           SELECT *, SYSDATE AS archived_at 
                           FROM contracts';
        DBMS_OUTPUT.PUT_LINE('Table original_contracts created with archived timestamp and data archived successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error creating table original_contracts: ' || SQLERRM);
    END;

    -- Optional Step: Log archive confirmation
    DECLARE
        record_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO record_count FROM original_contracts;
        DBMS_OUTPUT.PUT_LINE('Total records archived: ' || record_count);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error counting records in original_contracts: ' || SQLERRM);
    END;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error in archive process: ' || SQLERRM);
END;
/