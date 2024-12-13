/*
PL/SQL Script: backup_cleaned_data.sql
-------------------------------------------
Purpose:
This script creates a backup of the cleaned data in the `contracts` table by:
1. Creating a new table called `cleaned_contracts`.
2. Adding a primary key to ensure data integrity.
3. Adding indexes to optimize queries on the backup table.
4. Verifying the backup by checking the row count and previewing a few rows.

Features:
1. Error handling for each step to provide meaningful feedback.
2. Uses `DBMS_OUTPUT.PUT_LINE` to log progress and errors for debugging.
3. Verifies the integrity of the backup through a record count and sample data review.

Execution Notes:
- Ensure the `contracts` table contains cleaned data before running this script.
- Use `DBMS_OUTPUT.PUT_LINE` to view logs.
- Enable `SERVEROUTPUT` in your environment to display log messages.
*/

BEGIN
    -- Step 1: Check if the backup table exists and drop it
    BEGIN
        EXECUTE IMMEDIATE 'DROP TABLE cleaned_contracts';
        DBMS_OUTPUT.PUT_LINE('Existing table cleaned_contracts dropped successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE != -942 THEN -- ORA-00942: Table does not exist
                RAISE;
            ELSE
                DBMS_OUTPUT.PUT_LINE('Table cleaned_contracts does not exist. Proceeding to create it.');
            END IF;
    END;

    -- Step 2: Create the backup table and copy data
    BEGIN
        EXECUTE IMMEDIATE 'CREATE TABLE cleaned_contracts AS SELECT * FROM contracts';
        DBMS_OUTPUT.PUT_LINE('Table cleaned_contracts created successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error creating table cleaned_contracts: ' || SQLERRM);
    END;

    -- Step 3: Add primary key
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE cleaned_contracts ADD CONSTRAINT pk_cleaned_contracts PRIMARY KEY (ROW_KEY)';
        DBMS_OUTPUT.PUT_LINE('Primary key pk_cleaned_contracts added successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error adding primary key to cleaned_contracts: ' || SQLERRM);
    END;

    -- Step 4: Add an index to optimize vendor queries
    BEGIN
        EXECUTE IMMEDIATE 'CREATE INDEX idx_cleaned_contracts_vendor ON cleaned_contracts (LGL_NM)';
        DBMS_OUTPUT.PUT_LINE('Index idx_cleaned_contracts_vendor created successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error creating index on cleaned_contracts: ' || SQLERRM);
    END;

    -- Step 5: Verify the backup by counting records
    DECLARE
        record_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO record_count FROM cleaned_contracts;
        DBMS_OUTPUT.PUT_LINE('Total records in cleaned_contracts: ' || record_count);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error verifying record count in cleaned_contracts: ' || SQLERRM);
    END;

    -- Step 6: Preview the first few rows for review
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Previewing the first few rows of cleaned_contracts:');
        FOR rec IN (
            SELECT * 
            FROM cleaned_contracts
            FETCH FIRST 10 ROWS ONLY
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('ROW_KEY: ' || rec.ROW_KEY || ' | CONTRACT_SYNOPSIS: ' || rec.CONTRACT_SYNOPSIS || ' | VENDOR: ' || rec.LGL_NM);
        END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error previewing rows in cleaned_contracts: ' || SQLERRM);
    END;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error during the backup process: ' || SQLERRM);
END;
/

/*
Execution Instructions:
-------------------------------------------
1. Save this script as `backup_cleaned_data.sql`.
2. Open Oracle SQL Developer or another PL/SQL-compatible environment.
3. Enable `DBMS_OUTPUT` by running:
   SET SERVEROUTPUT ON;
4. Execute the script.
5. Verify the backup by:
   - Checking the record count in the logs.
   - Running a query to preview the contents:
     SELECT * FROM cleaned_contracts;
-------------------------------------------

Optional Enhancements:
-------------------------------------------
1. Add Additional Indexes:
   Create indexes on other frequently queried columns to optimize performance:
   EXECUTE IMMEDIATE 'CREATE INDEX idx_cleaned_contracts_date ON cleaned_contracts (EFBGN_DT)';

2. Archive Specific Columns or Rows:
   Modify the `SELECT` statement in Step 2 to archive only the required columns or rows:
   EXECUTE IMMEDIATE 'CREATE TABLE cleaned_contracts AS SELECT ROW_KEY, LGL_NM, MA_PRCH_LMT_AM FROM contracts WHERE MA_PRCH_LMT_AM > 0';

3. Add Timestamp:
   Include a timestamp column in the backup table to track when the data was archived:
   EXECUTE IMMEDIATE 'CREATE TABLE cleaned_contracts AS SELECT *, SYSDATE AS archived_at FROM contracts';
-------------------------------------------
*/