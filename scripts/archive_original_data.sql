/*
PL/SQL Script: archive_original_data.sql
-------------------------------------------
Purpose:
This script archives the original uncleaned data from the `contracts` table into a new table called `original_contracts`.
It ensures the original data is preserved for future reference or rollback purposes.

Features:
1. Checks if the `original_contracts` table already exists and drops it if necessary.
2. Creates the `original_contracts` table and copies all data from the `contracts` table.
3. Adds a timestamp column (`archived_at`) to the archive table to record when the data was archived.
4. Allows for selective archiving of columns or rows if needed.
5. Handles errors gracefully and provides feedback via `DBMS_OUTPUT`.

Execution Notes:
- Ensure the `contracts` table contains the uncleaned data before running this script.
- Use `DBMS_OUTPUT.PUT_LINE` to view feedback and logs.
- Run the script in Oracle SQL Developer or another PL/SQL-compatible environment.
*/

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

/*
Execution Instructions:
-------------------------------------------
1. Save this script as `archive_original_data.sql`.
2. Open Oracle SQL Developer or another PL/SQL-compatible environment.
3. Ensure `SET SERVEROUTPUT ON` is enabled to view feedback logs:
   SET SERVEROUTPUT ON;
4. Execute the script.
5. Verify the archive by running the following query:
   SELECT * FROM original_contracts;

-------------------------------------------
Optional Enhancements:
-------------------------------------------
1. Archive Only Specific Columns:
   Modify the `SELECT` statement to include only required columns:
   SELECT ROW_KEY, CONTRACT_SYNOPSIS, LGL_NM, MA_PRCH_LMT_AM, SYSDATE AS archived_at 
   FROM contracts;

2. Archive a Subset of Data:
   Add a `WHERE` clause to archive only rows that meet specific criteria:
   SELECT * 
   FROM contracts 
   WHERE MA_PRCH_LMT_AM > 0;

3. Add Indexes to the Archive Table:
   To optimize future queries, add indexes to the `original_contracts` table:
   EXECUTE IMMEDIATE 'CREATE INDEX idx_row_key ON original_contracts (ROW_KEY)';
-------------------------------------------
*/