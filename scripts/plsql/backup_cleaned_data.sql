/*=============================================================================================
   PL/SQL Script: backup_cleaned_data.sql
===============================================================================================

   💡 Purpose:
   --------------------------------------------------------------------------------------------
   This script creates a reliable backup of the cleaned data from the `contracts` table to 
   ensure data preservation, integrity, and accessibility for future reference.

   ✨ Features:
   --------------------------------------------------------------------------------------------
   ➜ Creates a backup table (`cleaned_contracts`) with a primary key for data integrity.
   ➜ Adds indexes to optimize query performance on the backup table.
   ➜ Implements error handling to ensure robust execution and detailed feedback.
   ➜ Logs progress, errors, and results using `DBMS_OUTPUT.PUT_LINE`.
   ➜ Verifies backup integrity by logging record counts and previewing sample data.

   🛠️ Execution Instructions:
   --------------------------------------------------------------------------------------------
   1️⃣ Save this script as `backup_cleaned_data.sql`.
   2️⃣ Open Oracle SQL Developer (or another PL/SQL-compatible environment).
   3️⃣ Enable server output by running:
       SET SERVEROUTPUT ON;
   4️⃣ Execute the script.
   5️⃣ Verify the backup by:
       ➤ Checking the record count in the logs.
       ➤ Previewing contents of the backup table:
           SELECT * FROM cleaned_contracts;

   🚀 Optional Enhancements:
   --------------------------------------------------------------------------------------------
   ➤ Add Additional Indexes:
       -- Optimize performance by creating indexes on frequently queried columns:
       
       EXECUTE IMMEDIATE 'CREATE INDEX idx_cleaned_contracts_date ON cleaned_contracts (EFBGN_DT)';

   ➤ Archive Specific Columns or Rows:
       -- Modify the backup process to include only specific columns or rows:
       
       EXECUTE IMMEDIATE 'CREATE TABLE cleaned_contracts AS 
                          SELECT ROW_KEY, LGL_NM, MA_PRCH_LMT_AM 
                          FROM contracts 
                          WHERE MA_PRCH_LMT_AM > 0';

   ➤ Add Timestamp for Backup Tracking:
       -- Include a timestamp column in the backup table for tracking:
       
       EXECUTE IMMEDIATE 'CREATE TABLE cleaned_contracts AS 
                          SELECT *, SYSDATE AS archived_at 
                          FROM contracts';

   ⚠️ Prerequisites:
   --------------------------------------------------------------------------------------------
   ⚙ Ensure the `contracts` table contains cleaned data before execution.
   ⚙ Verify database permissions to create tables and indexes.
   ⚙ Enable `DBMS_OUTPUT` to monitor progress and logs during execution.

=============================================================================================*/

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
🟢 BEGINNING OF SCRIPT 🟢
-----------------------------------------------------------------------------------------------
The backup process begins here. Safeguard your cleaned data with this automated solution, 
ensuring reliability, integrity, and accessibility for future use. Execute confidently!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

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