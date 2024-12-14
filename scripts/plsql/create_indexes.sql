/*=============================================================================================
   PL/SQL Script: create_indexes.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script creates indexes on the `contracts` table to improve query performance and ensure 
   data integrity for key operations.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Creates a unique index on the `ROW_KEY` column to enforce data uniqueness.
   ➜ Adds a standard index on the `LGL_NM` column to enhance vendor-based queries.
   ➜ Creates a standard index on the `EFBGN_DT` column to optimize date-based queries.
   ➜ Implements robust error handling for each `CREATE INDEX` operation with detailed feedback.
   ➜ Validates successful index creation with a verification query.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `create_indexes.sql`.
   2️⃣ Open Oracle SQL Developer (or another PL/SQL-compatible environment).
   3️⃣ Enable server output by running:
       SET SERVEROUTPUT ON;
   4️⃣ Execute the script.
   5️⃣ Review logs for:
       ➤ Success messages confirming index creation.
       ➤ Error messages, if any, for troubleshooting.
   6️⃣ Validate indexes using the following query:
       
       SELECT index_name, table_name, uniqueness
       FROM user_indexes
       WHERE table_name = 'CONTRACTS';

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Add Indexes for Frequently Queried Columns:
       
       EXECUTE IMMEDIATE 'CREATE INDEX idx_contract_status ON contracts(CONTRACT_STATUS)';
       

   ➤ Conditional Index Creation:
       -- Avoid redundant indexes by checking existence before creation:
       
       DECLARE
           v_count NUMBER;
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

   ➤ Automate Index Logging:
       -- Track index creation details for auditing purposes:
       
       EXECUTE IMMEDIATE 'CREATE TABLE index_log (
           index_name VARCHAR2(100), 
           status VARCHAR2(50), 
           created_at DATE DEFAULT SYSDATE
       )';
       INSERT INTO index_log (index_name, status) VALUES ('idx_row_key', 'Created Successfully');

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `contracts` table exists before running the script.
   ⚙ Verify database permissions to create indexes.
   ⚙ Enable `DBMS_OUTPUT` to monitor progress and logs.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
Boost your database performance by creating optimized indexes for the `contracts` table. 
Streamline queries, ensure data integrity, and elevate system efficiency. Let’s get started!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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