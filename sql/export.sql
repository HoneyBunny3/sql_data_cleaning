-- Export cleaned data to a CSV file
SELECT *
INTO OUTFILE '/path/to/exported_cleaned_data.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM contracts;