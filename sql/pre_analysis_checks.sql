-- Validate transformed data

-- Check for remaining null values
SELECT COLUMN_NAME, COUNT(*)
FROM contracts
WHERE COLUMN_NAME IS NULL
GROUP BY COLUMN_NAME;

-- Check for duplicate rows
SELECT ROW_KEY, COUNT(*)
FROM contracts
GROUP BY ROW_KEY
HAVING COUNT(*) > 1;

-- Verify monetary fields have valid values
SELECT *
FROM contracts
WHERE MA_PRCH_LMT_AM < 0 OR MA_ITD_ORD_AM < 0;