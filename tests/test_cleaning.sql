/*
PL/SQL Script: test_cleaning.sql
-------------------------------------------
Purpose:
This script validates the cleaned data in the `contracts` table, checking for:
1. Duplicates
2. NULL values in mandatory fields
3. Data ranges and field constraints
4. Field format consistency

Instructions:
- Run this script after executing the cleaning process.
- Review the results of each validation query.
*/

SET SERVEROUTPUT ON;

BEGIN
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('      VALIDATION TESTS FOR CLEANED DATA   ');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    
    -- Test 1: Check for duplicates
    DBMS_OUTPUT.PUT_LINE('Test 1: Checking for duplicate records...');
    FOR rec IN (
        SELECT employee_id, COUNT(*)
        FROM contracts
        GROUP BY employee_id, start_date, end_date
        HAVING COUNT(*) > 1
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Duplicate found: Employee ID: ' || rec.employee_id || ', Count: ' || rec.COUNT);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Test 1 Complete: Duplicate check done.');

    -- Test 2: Check for NULL values in mandatory fields
    DBMS_OUTPUT.PUT_LINE('Test 2: Checking for NULL values in mandatory fields...');
    FOR rec IN (
        SELECT *
        FROM contracts
        WHERE employee_id IS NULL
           OR employee_name IS NULL
           OR start_date IS NULL
           OR end_date IS NULL
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('NULL value detected in record with Contract ID: ' || rec.contract_id);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Test 2 Complete: NULL check done.');

    -- Test 3: Validate data ranges (e.g., start_date < end_date)
    DBMS_OUTPUT.PUT_LINE('Test 3: Checking for invalid date ranges...');
    FOR rec IN (
        SELECT *
        FROM contracts
        WHERE start_date >= end_date
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Invalid date range in Contract ID: ' || rec.contract_id || ', Start Date: ' || rec.start_date || ', End Date: ' || rec.end_date);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Test 3 Complete: Date range check done.');

    -- Test 4: Check for negative contract values
    DBMS_OUTPUT.PUT_LINE('Test 4: Checking for negative contract values...');
    FOR rec IN (
        SELECT *
        FROM contracts
        WHERE contract_value < 0
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Negative contract value detected in Contract ID: ' || rec.contract_id || ', Value: ' || rec.contract_value);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Test 4 Complete: Negative value check done.');

    -- Test 5: Validate field formats (e.g., date format, text capitalization)
    DBMS_OUTPUT.PUT_LINE('Test 5: Validating field formats...');
    FOR rec IN (
        SELECT *
        FROM contracts
        WHERE REGEXP_LIKE(employee_name, '[^A-Za-z ]') -- Employee name contains invalid characters
           OR NOT REGEXP_LIKE(start_date, '^\d{4}-\d{2}-\d{2}$') -- Start date not in YYYY-MM-DD format
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Invalid format detected in Contract ID: ' || rec.contract_id);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Test 5 Complete: Field format validation done.');

    DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Validation Tests Completed Successfully!');
    DBMS_OUTPUT.PUT_LINE('-----------------------------------------');
END;
/