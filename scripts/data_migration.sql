/*
PL/SQL Script: data_migration.sql
-------------------------------------------
Purpose:
This script migrates data from a staging table (`staging_contracts`) to the production `contracts` table.
It prevents duplicate entries by using a `NOT EXISTS` check.

Features:
1. Error handling to log meaningful feedback during the migration.
2. Uses `DBMS_OUTPUT.PUT_LINE` to provide detailed execution logs.
3. Ensures only new records are migrated.

Execution Notes:
- Ensure the `staging_contracts` table is populated and structure matches the `contracts` table.
- Enable `SERVEROUTPUT` to view logs.
*/

BEGIN
    -- Log the start of the migration process
    DBMS_OUTPUT.PUT_LINE('Starting data migration...');

    -- Perform the migration
    BEGIN
        INSERT INTO contracts (ROW_KEY, CONTRACT_SYNOPSIS, LGL_NM, MA_PRCH_LMT_AM, EFBGN_DT, EFEND_DT)
        SELECT ROW_KEY, CONTRACT_SYNOPSIS, LGL_NM, MA_PRCH_LMT_AM, EFBGN_DT, EFEND_DT
        FROM staging_contracts
        WHERE NOT EXISTS (
            SELECT 1 FROM contracts WHERE contracts.ROW_KEY = staging_contracts.ROW_KEY
        );
        DBMS_OUTPUT.PUT_LINE('Data migration completed successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error during data migration: ' || SQLERRM);
    END;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error during the data migration process: ' || SQLERRM);
END;
/

/*
Execution Instructions:
-------------------------------------------
1. Save this script as `data_migration.sql`.
2. Open Oracle SQL Developer or another PL/SQL-compatible environment.
3. Enable `DBMS_OUTPUT` by running:
   SET SERVEROUTPUT ON;
4. Execute the script.
5. Verify the migrated data using:
   SELECT COUNT(*) FROM contracts;
*/