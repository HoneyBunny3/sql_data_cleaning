/*
PL/SQL Script: clean_and_enhance_contracts.sql
-------------------------------------------
Purpose:
This script performs a comprehensive cleaning and enhancement of the `contracts` table by:
1. Removing duplicate rows based on `ROW_KEY`.
2. Replacing null and placeholder values in key columns.
3. Standardizing text and date fields for consistency.
4. Normalizing phone numbers and categorizing contracts.
5. Adding calculated fields such as `contract_size` and `contract_duration`.
6. Identifying potential data issues for further review.

Features:
1. Error handling for each operation to ensure robust execution.
2. Uses `DBMS_OUTPUT.PUT_LINE` to log progress and results for debugging.
3. Adds new columns (`contract_size`, `contract_duration`, `potential_issue`) with derived values.

Execution Notes:
- Ensure the `contracts` table exists and is backed up before running this script.
- Enable `SERVEROUTPUT` in your environment to display logs.
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

    -- Step 2: Replace null and placeholder values in key columns
    BEGIN
        EXECUTE IMMEDIATE 'UPDATE contracts SET CONTRACT_SYNOPSIS = ''Not Available'' WHERE CONTRACT_SYNOPSIS IS NULL';
        EXECUTE IMMEDIATE 'UPDATE contracts SET ALIAS_NM = ''No Alias'' WHERE ALIAS_NM IS NULL';
        EXECUTE IMMEDIATE 'UPDATE contracts SET CONTRACT_CONTACT_NM = ''Unknown Name'' WHERE CONTRACT_CONTACT_NM = ''unknown''';
        EXECUTE IMMEDIATE 'UPDATE contracts SET CONTRACT_CONTACT_VOICE_PH_NO = ''Unknown Phone'' WHERE CONTRACT_CONTACT_VOICE_PH_NO = ''unknown''';
        EXECUTE IMMEDIATE 'UPDATE contracts SET CONTRACT_CONTACT_EMAIL_AD = ''Unknown Email'' WHERE CONTRACT_CONTACT_EMAIL_AD = ''unknown''';
        DBMS_OUTPUT.PUT_LINE('Null and placeholder values replaced successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error replacing null/placeholder values: ' || SQLERRM);
    END;

    -- Step 3: Standardize text and date fields
    BEGIN
        EXECUTE IMMEDIATE 'UPDATE contracts SET LGL_NM = UPPER(TRIM(LGL_NM))';
        EXECUTE IMMEDIATE 'UPDATE contracts SET ALIAS_NM = UPPER(TRIM(ALIAS_NM))';
        EXECUTE IMMEDIATE 'UPDATE contracts SET EFBGN_DT = TO_DATE(EFBGN_DT, ''YYYY-MM-DD'') WHERE EFBGN_DT IS NOT NULL';
        EXECUTE IMMEDIATE 'UPDATE contracts SET EFEND_DT = TO_DATE(EFEND_DT, ''YYYY-MM-DD'') WHERE EFEND_DT IS NOT NULL';
        EXECUTE IMMEDIATE 'UPDATE contracts SET BRD_AWD_DT = TO_DATE(BRD_AWD_DT, ''YYYY-MM-DD'') WHERE BRD_AWD_DT IS NOT NULL';
        DBMS_OUTPUT.PUT_LINE('Text and date fields standardized successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error standardizing text/date fields: ' || SQLERRM);
    END;

    -- Step 4: Replace invalid dates and negative monetary values
    BEGIN
        EXECUTE IMMEDIATE 'UPDATE contracts SET EFBGN_DT = TO_DATE(''1900-01-01'', ''YYYY-MM-DD'') WHERE EFBGN_DT IS NULL OR EFBGN_DT = TO_DATE(''0000-00-00'', ''YYYY-MM-DD'')';
        EXECUTE IMMEDIATE 'UPDATE contracts SET EFEND_DT = TO_DATE(''1900-01-01'', ''YYYY-MM-DD'') WHERE EFEND_DT IS NULL OR EFEND_DT = TO_DATE(''0000-00-00'', ''YYYY-MM-DD'')';
        EXECUTE IMMEDIATE 'UPDATE contracts SET MA_PRCH_LMT_AM = 0 WHERE MA_PRCH_LMT_AM < 0';
        EXECUTE IMMEDIATE 'UPDATE contracts SET MA_ITD_ORD_AM = 0 WHERE MA_ITD_ORD_AM < 0';
        DBMS_OUTPUT.PUT_LINE('Invalid dates and negative monetary values replaced successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error replacing invalid dates or negative values: ' || SQLERRM);
    END;

    -- Step 5: Normalize phone numbers
    BEGIN
        EXECUTE IMMEDIATE '
            UPDATE contracts
            SET CONTRACT_CONTACT_VOICE_PH_NO = 
                ''('' || SUBSTR(CONTRACT_CONTACT_VOICE_PH_NO, 1, 3) || '') '' ||
                SUBSTR(CONTRACT_CONTACT_VOICE_PH_NO, 4, 3) || ''-'' ||
                SUBSTR(CONTRACT_CONTACT_VOICE_PH_NO, 7, 4)
            WHERE LENGTH(CONTRACT_CONTACT_VOICE_PH_NO) = 10';
        DBMS_OUTPUT.PUT_LINE('Phone numbers normalized successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error normalizing phone numbers: ' || SQLERRM);
    END;

    -- Step 6: Normalize category descriptions
    BEGIN
        EXECUTE IMMEDIATE 'UPDATE contracts SET CAT_DSCR = ''Construction'' WHERE CAT_DSCR LIKE ''%construction%''';
        EXECUTE IMMEDIATE 'UPDATE contracts SET CAT_DSCR = ''Other Contracting'' WHERE CAT_DSCR LIKE ''%other%''';
        DBMS_OUTPUT.PUT_LINE('Category descriptions normalized successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error normalizing category descriptions: ' || SQLERRM);
    END;

    -- Step 7: Categorize contracts and calculate contract duration
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE contracts ADD COLUMN contract_size VARCHAR2(10)';
        EXECUTE IMMEDIATE '
            UPDATE contracts
            SET contract_size = CASE
                WHEN MA_PRCH_LMT_AM < 100000 THEN ''Minor''
                ELSE ''Major''
            END';
        EXECUTE IMMEDIATE 'ALTER TABLE contracts ADD COLUMN contract_duration NUMBER';
        EXECUTE IMMEDIATE '
            UPDATE contracts
            SET contract_duration = ROUND((EFEND_DT - EFBGN_DT))
            WHERE EFBGN_DT IS NOT NULL AND EFEND_DT IS NOT NULL';
        DBMS_OUTPUT.PUT_LINE('Contract size and duration calculated successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error categorizing contracts or calculating duration: ' || SQLERRM);
    END;

    -- Step 8: Flag potential data issues
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE contracts ADD COLUMN potential_issue NUMBER(1) DEFAULT 0';
        EXECUTE IMMEDIATE 'UPDATE contracts SET potential_issue = 1 WHERE MA_PRCH_LMT_AM > 10000000';
        DBMS_OUTPUT.PUT_LINE('Potential data issues flagged successfully.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error flagging potential data issues: ' || SQLERRM);
    END;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error during data cleaning process: ' || SQLERRM);
END;
/

/*
Execution Instructions:
-------------------------------------------
1. Save this script as `clean_and_enhance_contracts.sql`.
2. Open Oracle SQL Developer or another PL/SQL-compatible environment.
3. Enable `DBMS_OUTPUT` by running:
   SET SERVEROUTPUT ON;
4. Execute the script.
5. Review the logs for progress, results, and any error messages.
6. Verify changes in the `contracts` table by running validation queries.

Optional Enhancements:
-------------------------------------------
1. Log changes to a separate audit table for traceability.
2. Add additional data checks for specific business rules.
3. Create automated reports summarizing the enhancements applied.
*/