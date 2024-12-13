# Project Workflow for Contracts Data Cleaning and Transformation

1. **Incorporate Automation**: Reflect the automation script `automated_cleaning_job.sql` and the `clean_and_transform_contracts` procedure into the workflow to showcase automated processes.

2. **Add Logging and Auditing**: Highlight the use of the `audit_logging.sql` script to track changes in the `contracts` table.

3. **Include Indexing and Optimization**: Emphasize performance optimization via `create_indexes.sql` and `performance_optimization.sql`.

4. **Expand Documentation References**: Add the `validation_results_summary.md` and `analysis_report.md` as part of the documentation for reproducibility and reporting.

---

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
  ```
- **Objective**: Ensure the data is loaded into a structured table for further processing.

---

### **Step 2: Automated Cleaning**
- **Objective**: Automate the cleaning and transformation process to ensure consistency.

#### **Script**:
- Execute the `automated_cleaning_job.sql` script:
  ```sql
  CALL clean_and_transform_contracts();
  ```

- **Benefits**:
  - Automates duplicate removal, null handling, and standardization.
  - Enriches data with derived fields such as `contract_size` and `contract_duration`.

---

### **Step 3: Data Validation**
- **Objective**: Validate the dataset to ensure it meets quality standards.

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

### **Step 4: Performance Optimization**
- **Objective**: Enhance database performance for faster query execution.

#### **Actions Performed**:
1. **Create Indexes**:
   ```sql
   CREATE UNIQUE INDEX idx_row_key ON contracts(ROW_KEY);
   CREATE INDEX idx_vendor_name ON contracts(LGL_NM);
   CREATE INDEX idx_efbgn_dt ON contracts(EFBGN_DT);
   ```

2. **Rebuild Indexes and Gather Statistics**:
   - Execute the `performance_optimization.sql` script to optimize the database.

---

### **Step 5: Logging and Auditing**
- **Objective**: Track all changes made to the `contracts` table for traceability.

#### **Actions Performed**:
1. **Log Changes**:
   - Use the `audit_logging.sql` script to log details of each transformation.
   - Example log entry:
     ```sql
     INSERT INTO audit_log (action, table_name, details)
     VALUES ('Cleaned Data', 'contracts', 'Removed duplicates and standardized fields.');
     ```

2. **Review Logs**:
   ```sql
   SELECT * FROM audit_log;
   ```

---

### **Step 6: Data Analysis**
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

### **Step 7: Data Export**
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

### **8. Documentation**
- **Objective**: Ensure all processes are well-documented for reproducibility.

#### **Key Documents**:
1. `README.md`: Project overview.
2. `transformation_documentation.md`: Details of cleaning and transformation steps.
3. `validation_results_summary.md`: Summary of validation outcomes.
4. `analysis_report.md`: Insights and metrics derived from the cleaned dataset.

---

## **Tools and Technologies**
- **Database**: MySQL
- **Scripting Language**: SQL, PL/SQL
- **Visualization**: Tableau, Power BI
- **Other Tools**: Python (for optional data manipulation)

---