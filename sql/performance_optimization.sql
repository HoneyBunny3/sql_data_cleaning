/*
PL/SQL Script: performance_optimization.sql
-------------------------------------------
Purpose:
This script optimizes database performance by gathering statistics and rebuilding indexes for the `contracts` table.

Features:
1. Rebuilds existing indexes to improve query performance.
2. Gathers table statistics for better query optimization.
3. Logs the execution process using `DBMS_OUTPUT.PUT_LINE`.

Execution Notes:
- Ensure the database has sufficient resources for index rebuilding.
- Execute during off-peak hours to avoid performance issues.
*/

BEGIN
    -- Log the start of the optimization process
    DBMS_OUTPUT.PUT_LINE('Starting performance optimization process...');

    -- Gather table statistics
    BEGIN
        DBMS_STATS.GATHER_TABLE_STATS('SCHEMA_NAME', 'contracts');
        DBMS_OUTPUT.PUT_LINE('Table statistics gathered successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error gathering table statistics: ' || SQLERRM);
    END;

    -- Rebuild indexes
    BEGIN
        EXECUTE IMMEDIATE 'ALTER INDEX idx_row_key REBUILD';
        DBMS_OUTPUT.PUT_LINE('Index idx_row_key rebuilt successfully.');

        EXECUTE IMMEDIATE 'ALTER INDEX idx_vendor_name REBUILD';
        DBMS_OUTPUT.PUT_LINE('Index idx_vendor_name rebuilt successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error rebuilding indexes: ' || SQLERRM);
    END;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error during performance optimization: ' || SQLERRM);
END;
/

/*
Execution Instructions:
-------------------------------------------
1. Save this script as `performance_optimization.sql`.
2. Open Oracle SQL Developer or another PL/SQL-compatible environment.
3. Enable `DBMS_OUTPUT` by running:
   SET SERVEROUTPUT ON;
4. Execute the script.
5. Verify the optimization results by testing query performance.
*/