/*
Export Script: export_cleaned_data.sql
--------------------------------------
This script exports cleaned data from the `contracts` table to a CSV file
in the 'data/cleaned' directory of the repository. It includes:
1. A header row with column names.
2. Cleaned data rows from the table.
Ensure the directory exists and has proper permissions.
*/
SELECT 'ROW_KEY,CONTRACT_SYNOPSIS,CONTRACT_CONTACT_NM,CONTRACT_CONTACT_VOICE_PH_NO,CONTRACT_CONTACT_EMAIL_AD,MA_PRCH_LMT_AM,MA_ITD_ORD_AM,EFBGN_DT,EFEND_DT'
INTO OUTFILE 'data/cleaned/exported_cleaned_data.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n';

/*
Append the cleaned data to the file. Dates are formatted as YYYY-MM-DD for consistency.
*/
SELECT ROW_KEY, 
       CONTRACT_SYNOPSIS, 
       CONTRACT_CONTACT_NM, 
       CONTRACT_CONTACT_VOICE_PH_NO, 
       CONTRACT_CONTACT_EMAIL_AD, 
       MA_PRCH_LMT_AM, 
       MA_ITD_ORD_AM, 
       DATE_FORMAT(EFBGN_DT, '%Y-%m-%d') AS EFBGN_DT, 
       DATE_FORMAT(EFEND_DT, '%Y-%m-%d') AS EFEND_DT
INTO OUTFILE 'data/cleaned/exported_cleaned_data.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM contracts;