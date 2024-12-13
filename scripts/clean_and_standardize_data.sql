/*
PL/SQL Script: clean_and_standardize_data.sql
-------------------------------------------
Purpose:
This script performs cleaning and standardization of the `contracts` table by:
1. Removing duplicate rows based on the `ROW_KEY` column.
2. Handling null or unknown values in key fields.
3. Standardizing date formats and handling invalid dates.
4. Replacing negative monetary values with 0.
5. Normalizing text fields and phone numbers for consistency.
6. Normalizing category descriptions for uniformity.

Features:
1. Error handling for each operation to log meaningful feedback.
2. Uses `DBMS_OUTPUT.PUT_LINE` to log progress and results for debugging.
3. Includes validation queries to check for anomalies after cleaning.

Execution Notes:
- Ensure the `contracts` table is backed up before running this script.
- Use `DBMS_OUTPUT.PUT_LINE` to log operations and errors.
- Enable `SERVEROUTPUT` in your environment to view output logs.
*/

BEGIN
    -- Step 1: Remove duplicate rows based on ROW_KEY
    BEGIN
        EXECUTE IMMEDIATE '
            DELETE FROM contracts
            WHERE ROW_KEY NOT IN (
                SELECT ROW_KEY
                FROM (
                    SELECT ROW_KEY, MIN(ROW_KEY) OVER (PARTITION BY ROW_KEY) AS min_row
                    FROM contracts
                ) temp
                WHERE ROW_KEY = min_row
            )';
        DBMS_OUTPUT.PUT_LINE('Duplicate rows removed successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error removing duplicate rows: ' || SQLERRM);
    END;

    -- Step 2: Handle null values in key fields
    BEGIN
        EXECUTE IMMEDIATE 'UPDATE contracts SET CONTRACT_SYNOPSIS = ''Not Available'' WHERE CONTRACT_SYNOPSIS IS NULL';
        DBMS_OUTPUT.PUT_LINE('Null values in CONTRACT_SYNOPSIS replaced successfully.');

        EXECUTE IMMEDIATE 'UPDATE contracts SET ALIAS_NM = ''No Alias'' WHERE ALIAS_NM IS NULL';
        DBMS_OUTPUT.PUT_LINE('Null values in ALIAS_NM replaced successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error handling null values: ' || SQLERRM);
    END;

    -- Step 3: Replace 'unknown' values in contact fields
    BEGIN
        EXECUTE IMMEDIATE 'UPDATE contracts SET CONTRACT_CONTACT_NM = ''Unknown Name'' WHERE CONTRACT_CONTACT_NM = ''unknown''';
        EXECUTE IMMEDIATE 'UPDATE contracts SET CONTRACT_CONTACT_VOICE_PH_NO = ''Unknown Phone'' WHERE CONTRACT_CONTACT_VOICE_PH_NO = ''unknown''';
        EXECUTE IMMEDIATE 'UPDATE contracts SET CONTRACT_CONTACT_EMAIL_AD = ''Unknown Email'' WHERE CONTRACT_CONTACT_EMAIL_AD = ''unknown''';
        DBMS_OUTPUT.PUT_LINE('Unknown values in contact fields replaced successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error replacing unknown values in contact fields: ' || SQLERRM);
    END;

    -- Step 4: Standardize and handle invalid dates
    BEGIN
        EXECUTE IMMEDIATE 'UPDATE contracts SET EFBGN_DT = TO_DATE(''1900-01-01'', ''YYYY-MM-DD'') WHERE EFBGN_DT IS NULL OR EFBGN_DT = TO_DATE(''0000-00-00'', ''YYYY-MM-DD'')';
        EXECUTE IMMEDIATE 'UPDATE contracts SET EFEND_DT = TO_DATE(''1900-01-01'', ''YYYY-MM-DD'') WHERE EFEND_DT IS NULL OR EFEND_DT = TO_DATE(''0000-00-00'', ''YYYY-MM-DD'')';
        EXECUTE IMMEDIATE 'UPDATE contracts SET BRD_AWD_DT = TO_DATE(''1900-01-01'', ''YYYY-MM-DD'') WHERE BRD_AWD_DT IS NULL OR BRD_AWD_DT = TO_DATE(''0000-00-00'', ''YYYY-MM-DD'')';
        DBMS_OUTPUT.PUT_LINE('Dates standardized and invalid values handled successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error handling dates: ' || SQLERRM);
    END;

    -- Step 5: Replace negative monetary values with 0
    BEGIN
        EXECUTE IMMEDIATE 'UPDATE contracts SET MA_PRCH_LMT_AM = 0 WHERE MA_PRCH_LMT_AM < 0';
        EXECUTE IMMEDIATE 'UPDATE contracts SET MA_ITD_ORD_AM = 0 WHERE MA_ITD_ORD_AM < 0';
        DBMS_OUTPUT.PUT_LINE('Negative monetary values replaced with 0 successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error replacing negative monetary values: ' || SQLERRM);
    END;

    -- Step 6: Standardize text fields and normalize phone numbers
    BEGIN
        EXECUTE IMMEDIATE 'UPDATE contracts SET LGL_NM = UPPER(TRIM(LGL_NM))';
        EXECUTE IMMEDIATE 'UPDATE contracts SET ALIAS_NM = UPPER(TRIM(ALIAS_NM))';
        EXECUTE IMMEDIATE '
            UPDATE contracts
            SET CONTRACT_CONTACT_VOICE_PH_NO = 
                ''('' || SUBSTR(CONTRACT_CONTACT_VOICE_PH_NO, 1, 3) || '') '' ||
                SUBSTR(CONTRACT_CONTACT_VOICE_PH_NO, 4, 3) || ''-'' ||
                SUBSTR(CONTRACT_CONTACT_VOICE_PH_NO, 7, 4)
            WHERE LENGTH(CONTRACT_CONTACT_VOICE_PH_NO) = 10';
        DBMS_OUTPUT.PUT_LINE('Text fields standardized and phone numbers normalized successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error standardizing text fields or normalizing phone numbers: ' || SQLERRM);
    END;

    -- Step 7: Normalize category descriptions
    BEGIN
        EXECUTE IMMEDIATE 'UPDATE contracts SET CAT_DSCR = ''Construction'' WHERE CAT_DSCR LIKE ''%construction%''';
        DBMS_OUTPUT.PUT_LINE('Category descriptions normalized successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error normalizing category descriptions: ' || SQLERRM);
    END;

    -- Step 8: Validation query to check for anomalies
    BEGIN
        DECLARE
            high_value_count NUMBER;
        BEGIN
            SELECT COUNT(*) INTO high_value_count FROM contracts WHERE MA_PRCH_LMT_AM > 10000000;
            DBMS_OUTPUT.PUT_LINE('Number of contracts with unusually high spending: ' || high_value_count);
        END;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error running validation query: ' || SQLERRM);
    END;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error during data cleaning: ' || SQLERRM);
END;
/

/*
Execution Instructions:
-------------------------------------------
1. Save this script as `clean_and_standardize_data.sql`.
2. Open Oracle SQL Developer or another PL/SQL-compatible environment.
3. Enable `DBMS_OUTPUT` by running:
   SET SERVEROUTPUT ON;
4. Execute the script.
5. Review the logs for progress and error messages.

Optional Enhancements:
-------------------------------------------
1. Add additional data validation queries to check for specific anomalies.
2. Create a report summarizing the changes made during cleaning.
3. Extend the script to log results into a separate audit table.
*/