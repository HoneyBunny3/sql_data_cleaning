-- Remove duplicate rows based on ROW_KEY
DELETE FROM contracts
WHERE ROW_KEY NOT IN (
    SELECT MIN(ROW_KEY)
    FROM contracts
    GROUP BY ROW_KEY
);

-- Replace null values in CONTRACT_SYNOPSIS with a default placeholder
UPDATE contracts
SET CONTRACT_SYNOPSIS = 'Not Available'
WHERE CONTRACT_SYNOPSIS IS NULL;

-- Replace null values in ALIAS_NM with 'No Alias'
UPDATE contracts
SET ALIAS_NM = 'No Alias'
WHERE ALIAS_NM IS NULL;

-- Replace 'unknown' values in contact fields with appropriate placeholders
UPDATE contracts
SET CONTRACT_CONTACT_NM = 'Unknown Name'
WHERE CONTRACT_CONTACT_NM = 'unknown';

UPDATE contracts
SET CONTRACT_CONTACT_VOICE_PH_NO = 'Unknown Phone'
WHERE CONTRACT_CONTACT_VOICE_PH_NO = 'unknown';

UPDATE contracts
SET CONTRACT_CONTACT_EMAIL_AD = 'Unknown Email'
WHERE CONTRACT_CONTACT_EMAIL_AD = 'unknown';

-- Standardize vendor and contractor names (uppercase and trim whitespace)
UPDATE contracts
SET LGL_NM = UPPER(TRIM(LGL_NM));

UPDATE contracts
SET ALIAS_NM = UPPER(TRIM(ALIAS_NM));

-- Standardize date formats to YYYY-MM-DD
UPDATE contracts
SET EFBGN_DT = STR_TO_DATE(EFBGN_DT, '%m/%d/%Y');

UPDATE contracts
SET EFEND_DT = STR_TO_DATE(EFEND_DT, '%m/%d/%Y');

UPDATE contracts
SET BRD_AWD_DT = STR_TO_DATE(BRD_AWD_DT, '%m/%d/%Y');

-- Handle invalid or missing dates
UPDATE contracts
SET EFBGN_DT = '1900-01-01'
WHERE EFBGN_DT IS NULL OR EFBGN_DT = '0000-00-00';

UPDATE contracts
SET EFEND_DT = '1900-01-01'
WHERE EFEND_DT IS NULL OR EFEND_DT = '0000-00-00';

UPDATE contracts
SET BRD_AWD_DT = '1900-01-01'
WHERE BRD_AWD_DT IS NULL OR BRD_AWD_DT = '0000-00-00';

-- Replace negative monetary values with 0
UPDATE contracts
SET MA_PRCH_LMT_AM = 0
WHERE MA_PRCH_LMT_AM < 0;

UPDATE contracts
SET MA_ITD_ORD_AM = 0
WHERE MA_ITD_ORD_AM < 0;

-- Normalize phone numbers to (XXX) XXX-XXXX format
UPDATE contracts
SET CONTRACT_CONTACT_VOICE_PH_NO = 
    CONCAT('(', SUBSTRING(CONTRACT_CONTACT_VOICE_PH_NO, 1, 3), ') ',
    SUBSTRING(CONTRACT_CONTACT_VOICE_PH_NO, 4, 3), '-',
    SUBSTRING(CONTRACT_CONTACT_VOICE_PH_NO, 7, 4))
WHERE LENGTH(CONTRACT_CONTACT_VOICE_PH_NO) = 10;

-- Normalize category descriptions for consistency
UPDATE contracts
SET CAT_DSCR = 'Construction'
WHERE CAT_DSCR LIKE '%construction%';

UPDATE contracts
SET CAT_DSCR = 'Other Contracting'
WHERE CAT_DSCR LIKE '%other%';

-- Categorize contracts into "Minor" and "Major" based on purchase limit
ALTER TABLE contracts ADD COLUMN contract_size VARCHAR(10);
UPDATE contracts
SET contract_size = CASE
    WHEN MA_PRCH_LMT_AM < 100000 THEN 'Minor'
    ELSE 'Major'
END;

-- Calculate contract duration in days
ALTER TABLE contracts ADD COLUMN contract_duration INT;
UPDATE contracts
SET contract_duration = DATEDIFF(EFEND_DT, EFBGN_DT)
WHERE EFBGN_DT IS NOT NULL AND EFEND_DT IS NOT NULL;

-- Flag potential data issues (e.g., contracts with unusually high spending)
ALTER TABLE contracts ADD COLUMN potential_issue BOOLEAN DEFAULT FALSE;
UPDATE contracts
SET potential_issue = TRUE
WHERE MA_PRCH_LMT_AM > 10000000; -- Example threshold