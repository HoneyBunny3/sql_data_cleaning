# Project Workflow for Contracts Data Cleaning and Transformation

This document outlines the complete workflow for cleaning, transforming, and analyzing the `contracts` dataset. It includes detailed steps, tools used, and processes followed to prepare the data for meaningful analysis and reporting.

---

## **1. Project Overview**
The goal of this project is to clean and transform the `contracts` dataset from the City of Austin Contracts Database to prepare it for analysis. The workflow ensures the data is accurate, consistent, and enriched with additional insights, aligning with industry standards for contract reporting.

---

## **2. Workflow Steps**

### **Step 1: Data Import**
- **Action**: Import the raw dataset into the database.
- **Tools**: MySQL, Python (optional for file manipulation).
- **SQL Command**:
  ```sql
  LOAD DATA INFILE '/path/to/contracts.csv'
  INTO TABLE contracts
  FIELDS TERMINATED BY ',' ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;

- **Objective**: Ensure the data is loaded into a structured table for further processing.

---

### **Step 2: Data Cleaning**
- **Objective**: Remove inconsistencies, duplicates, and missing or invalid data.

#### **Actions Performed**:
1. **Remove Duplicate Rows**:
   - Retain unique rows based on the `ROW_KEY` column.
   ```sql
   DELETE FROM contracts
   WHERE ROW_KEY NOT IN (
       SELECT MIN(ROW_KEY)
       FROM contracts
       GROUP BY ROW_KEY
   );
   ```

2. **Handle Missing Values**:
   - Replace null values in key columns with default placeholders.
   ```sql
   UPDATE contracts
   SET CONTRACT_SYNOPSIS = 'Not Available'
   WHERE CONTRACT_SYNOPSIS IS NULL;
   ```

3. **Standardize Data Formats**:
   - Convert dates to the `YYYY-MM-DD` format.
   ```sql
   UPDATE contracts
   SET EFBGN_DT = STR_TO_DATE(EFBGN_DT, '%m/%d/%Y');
   ```

4. **Normalize Text Fields**:
   - Standardize names to uppercase and trim unnecessary whitespace.
   ```sql
   UPDATE contracts
   SET LGL_NM = UPPER(TRIM(LGL_NM));
   ```

---

### **Step 3: Data Transformation**
- **Objective**: Enrich the dataset with new columns and prepare it for analysis.

#### **Actions Performed**:
1. **Add Derived Columns**:
   - `contract_size`: Categorize contracts as "Minor" or "Major."
   ```sql
   ALTER TABLE contracts ADD COLUMN contract_size VARCHAR(10);
   UPDATE contracts
   SET contract_size = CASE
       WHEN MA_PRCH_LMT_AM < 100000 THEN 'Minor'
       ELSE 'Major'
   END;
   ```

   - `contract_duration`: Calculate contract duration in days.
   ```sql
   ALTER TABLE contracts ADD COLUMN contract_duration INT;
   UPDATE contracts
   SET contract_duration = DATEDIFF(EFEND_DT, EFBGN_DT)
   WHERE EFBGN_DT IS NOT NULL AND EFEND_DT IS NOT NULL;
   ```

2. **Flag Potential Data Issues**:
   - Identify contracts with unusually high spending for manual review.
   ```sql
   ALTER TABLE contracts ADD COLUMN potential_issue BOOLEAN DEFAULT FALSE;
   UPDATE contracts
   SET potential_issue = TRUE
   WHERE MA_PRCH_LMT_AM > 10000000;
   ```

---

### **Step 4: Data Validation**
- **Objective**: Ensure the dataset is clean and ready for analysis.

#### **Validation Steps**:
1. **Check for Remaining Null Values**:
   ```sql
   SELECT COLUMN_NAME, COUNT(*)
   FROM contracts
   WHERE COLUMN_NAME IS NULL
   GROUP BY COLUMN_NAME;
   ```

2. **Verify Monetary Fields**:
   ```sql
   SELECT *
   FROM contracts
   WHERE MA_PRCH_LMT_AM < 0 OR MA_ITD_ORD_AM < 0;
   ```

3. **Inspect Key Metrics**:
   - Confirm the validity of derived fields (`contract_size`, `contract_duration`).

---

### **Step 5: Data Analysis**
- **Objective**: Generate insights and prepare data for reporting.

#### **Actions Performed**:
1. **Category-Level Analysis**:
   ```sql
   SELECT CAT_DSCR, SUM(MA_PRCH_LMT_AM) AS total_spent
   FROM contracts
   GROUP BY CAT_DSCR
   ORDER BY total_spent DESC;
   ```

2. **Vendor Performance**:
   ```sql
   SELECT LGL_NM, COUNT(*) AS contract_count, SUM(MA_PRCH_LMT_AM) AS total_spent
   FROM contracts
   GROUP BY LGL_NM
   ORDER BY total_spent DESC;
   ```

3. **Spending Trends Over Time**:
   ```sql
   SELECT YEAR(EFBGN_DT) AS year, SUM(MA_PRCH_LMT_AM) AS total_spent
   FROM contracts
   WHERE EFBGN_DT IS NOT NULL
   GROUP BY YEAR(EFBGN_DT)
   ORDER BY year;
   ```

---

### **Step 6: Data Export**
- **Objective**: Save the cleaned and transformed data for visualization or external analysis.

#### **Export Script**:
```sql
SELECT *
INTO OUTFILE '/path/to/exported_cleaned_data.csv'
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
FROM contracts;
```

---

### **7. Documentation**
- **Objective**: Ensure all processes are well-documented for reproducibility.
- **Files**:
  - `README.md`: Project overview.
  - `data_dictionary.md`: Description of dataset fields.
  - `transformation_documentation.md`: Details of cleaning and transformation steps.

---

## **Tools and Technologies**
- **Database**: MySQL
- **Scripting Language**: SQL
- **Visualization**: Tableau, Power BI (optional)
- **Other Tools**: Python (for optional data manipulation)

---

## **8. Next Steps**
1. Use the cleaned data to build dashboards in Tableau or Power BI.
2. Automate the cleaning and transformation process for recurring updates.
3. Enhance the analysis with additional insights, such as outlier detection or trend forecasting.

---

This workflow ensures a robust, end-to-end process for preparing the `contracts` dataset for analysis. Follow the steps sequentially to replicate the results or adapt them to your specific needs.

---

### **How to Use This File**
1. Save this as `docs/project_workflow.md` in your repository.
2. Use it as a step-by-step guide to ensure all parts of your project are executed consistently.
3. Update it as needed when you refine or expand the project.
***