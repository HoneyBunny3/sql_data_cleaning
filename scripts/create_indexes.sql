/*
PL/SQL Script: create_indexes.sql
-------------------------------------------
Purpose:
This script creates indexes on the `contracts` table to optimize query performance:
1. A unique index on the `ROW_KEY` column ensures data uniqueness.
2. A standard index on the `LGL_NM` column improves vendor-based queries.
3. A standard index on the `EFBGN_DT` column optimizes date-based queries.

Features:
1. Error handling for each `CREATE INDEX` operation to log meaningful feedback.
2. Uses `DBMS_OUTPUT.PUT_LINE` for detailed logging and debugging.
3. Includes a query to validate index creation after execution.

Execution Notes:
- Ensure the `contracts` table exists before running this script.
- Enable `SERVEROUTPUT` to display feedback logs.
- Execute the script in an Oracle SQL environment that supports PL/SQL.
*/

BEGIN
    -- Step 1: Add a unique index to the ROW_KEY column for uniqueness
    BEGIN
        EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX idx_row_key ON contracts(ROW_KEY)';
        DBMS_OUTPUT.PUT_LINE('Unique index idx_row_key created successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error creating unique index idx_row_key: ' || SQLERRM);
    END;

    -- Step 2: Add an index to LGL_NM for vendor-based queries
    BEGIN
        EXECUTE IMMEDIATE 'CREATE INDEX idx_vendor_name ON contracts(LGL_NM)';
        DBMS_OUTPUT.PUT_LINE('Index idx_vendor_name created successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error creating index idx_vendor_name: ' || SQLERRM);
    END;

    -- Step 3: Add an index to EFBGN_DT for date-based queries
    BEGIN
        EXECUTE IMMEDIATE 'CREATE INDEX idx_efbgn_dt ON contracts(EFBGN_DT)';
        DBMS_OUTPUT.PUT_LINE('Index idx_efbgn_dt created successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error creating index idx_efbgn_dt: ' || SQLERRM);
    END;

    -- Step 4: Validate index creation
    BEGIN
        FOR rec IN (
            SELECT index_name, table_name, uniqueness
            FROM user_indexes
            WHERE table_name = 'CONTRACTS'
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('Index Found: ' || rec.index_name || ' | Table: ' || rec.table_name || ' | Uniqueness: ' || rec.uniqueness);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error validating indexes: ' || SQLERRM);
    END;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error during index creation process: ' || SQLERRM);
END;
/

/*
Execution Instructions:
-------------------------------------------
1. Save this script as `create_indexes.sql`.
2. Open Oracle SQL Developer or another PL/SQL-compatible environment.
3. Enable `DBMS_OUTPUT` by running:
   SET SERVEROUTPUT ON;
4. Execute the script.
5. Review the logs for success or error messages for each index creation step.
6. Validate the indexes using the following query:
   SELECT index_name, table_name, uniqueness
   FROM user_indexes
   WHERE table_name = 'CONTRACTS';

Optional Enhancements:
-------------------------------------------
1. Add Index for Frequently Queried Columns:
   - Create additional indexes for other commonly queried columns:
     EXECUTE IMMEDIATE 'CREATE INDEX idx_contract_status ON contracts(CONTRACT_STATUS)';

2. Conditional Index Creation:
   - Check if an index exists before creating it:
     BEGIN
         SELECT COUNT(*) INTO v_count
         FROM user_indexes
         WHERE table_name = 'CONTRACTS' AND index_name = 'IDX_ROW_KEY';
         IF v_count = 0 THEN
             EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX idx_row_key ON contracts(ROW_KEY)';
             DBMS_OUTPUT.PUT_LINE('Index idx_row_key created successfully.');
         ELSE
             DBMS_OUTPUT.PUT_LINE('Index idx_row_key already exists.');
         END IF;
     END;

3. Automate Index Logging:
   - Create a log table to record index creation details and errors for auditing:
     EXECUTE IMMEDIATE 'CREATE TABLE index_log (index_name VARCHAR2(100), status VARCHAR2(50), created_at DATE DEFAULT SYSDATE)';
     INSERT INTO index_log (index_name, status) VALUES ('idx_row_key', 'Created Successfully');
*/