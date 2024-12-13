/*
PL/SQL Script: data_rollback.sql
-------------------------------------------
Purpose:
This script restores the `contracts` table to its original state using data from the `original_contracts` backup table.

Features:
1. Error handling to ensure robust execution.
2. Uses `DBMS_OUTPUT.PUT_LINE` to log progress and errors.
3. Deletes all current data in the `contracts` table and restores the original data.

Execution Notes:
- Ensure the `original_contracts` table contains the original data before executing this script.
- Backup the current `contracts` table if necessary.
*/

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

/*
Execution Instructions:
-------------------------------------------
1. Save this script as `data_rollback.sql`.
2. Open Oracle SQL Developer or another PL/SQL-compatible environment.
3. Enable `DBMS_OUTPUT` by running:
   SET SERVEROUTPUT ON;
4. Execute the script.
5. Verify the restored data using:
   SELECT COUNT(*) FROM contracts;
*/