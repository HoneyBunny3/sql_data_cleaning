-- Total Spending Per Category
SELECT 
    CAT_DSCR AS category,
    SUM(MA_PRCH_LMT_AM) AS total_spent,
    ROUND(SUM(MA_PRCH_LMT_AM) / (SELECT SUM(MA_PRCH_LMT_AM) FROM contracts) * 100, 2) AS percent_contribution
FROM contracts
WHERE MA_PRCH_LMT_AM > 0 -- Exclude invalid or zero values
GROUP BY CAT_DSCR
ORDER BY total_spent DESC;

-- Count of Contracts by Vendor
SELECT 
    LGL_NM AS vendor_name,
    COUNT(*) AS contract_count,
    SUM(MA_PRCH_LMT_AM) AS total_spent,
    ROUND(AVG(MA_PRCH_LMT_AM), 2) AS avg_contract_value
FROM contracts
WHERE MA_PRCH_LMT_AM > 0 -- Exclude invalid or zero values
GROUP BY LGL_NM
ORDER BY total_spent DESC;

-- Spending Trends Over Time (Monthly Granularity)
SELECT 
    YEAR(EFBGN_DT) AS year,
    MONTH(EFBGN_DT) AS month,
    SUM(MA_PRCH_LMT_AM) AS total_spent,
    COUNT(*) AS contract_count
FROM contracts
WHERE EFBGN_DT IS NOT NULL AND MA_PRCH_LMT_AM > 0 -- Exclude invalid data
GROUP BY YEAR(EFBGN_DT), MONTH(EFBGN_DT)
ORDER BY year, month;

-- Total Number of Contracts and Spending Per Year
SELECT 
    YEAR(EFBGN_DT) AS year,
    COUNT(*) AS total_contracts,
    SUM(MA_PRCH_LMT_AM) AS total_spent
FROM contracts
WHERE EFBGN_DT IS NOT NULL AND MA_PRCH_LMT_AM > 0 -- Exclude invalid data
GROUP BY YEAR(EFBGN_DT)
ORDER BY year;

-- Top 10 Vendors by Contract Count
SELECT 
    LGL_NM AS vendor_name,
    COUNT(*) AS contract_count
FROM contracts
WHERE MA_PRCH_LMT_AM > 0 -- Exclude invalid or zero values
GROUP BY LGL_NM
ORDER BY contract_count DESC
LIMIT 10;

-- Average Contract Duration in Days
SELECT 
    ROUND(AVG(DATEDIFF(EFEND_DT, EFBGN_DT)), 2) AS avg_contract_duration
FROM contracts
WHERE EFBGN_DT IS NOT NULL AND EFEND_DT IS NOT NULL; -- Ensure both dates are valid

-- Vendor with the Highest Spending Per Year
SELECT 
    YEAR(EFBGN_DT) AS year,
    LGL_NM AS vendor_name,
    SUM(MA_PRCH_LMT_AM) AS total_spent
FROM contracts
WHERE EFBGN_DT IS NOT NULL AND MA_PRCH_LMT_AM > 0 -- Exclude invalid data
GROUP BY YEAR(EFBGN_DT), LGL_NM
ORDER BY year, total_spent DESC
LIMIT 1;

-- Total Spending Per Category with Percentage Contribution
SELECT 
    CAT_DSCR AS category,
    SUM(MA_PRCH_LMT_AM) AS total_spent,
    ROUND(SUM(MA_PRCH_LMT_AM) / (SELECT SUM(MA_PRCH_LMT_AM) FROM contracts) * 100, 2) AS percent_contribution
FROM contracts
WHERE MA_PRCH_LMT_AM > 0 -- Exclude invalid or zero values
GROUP BY CAT_DSCR
ORDER BY total_spent DESC;

-- Spending Trends by Vendor Per Year
SELECT 
    YEAR(EFBGN_DT) AS year,
    LGL_NM AS vendor_name,
    SUM(MA_PRCH_LMT_AM) AS total_spent
FROM contracts
WHERE EFBGN_DT IS NOT NULL AND MA_PRCH_LMT_AM > 0 -- Exclude invalid data
GROUP BY YEAR(EFBGN_DT), LGL_NM
ORDER BY year, total_spent DESC;