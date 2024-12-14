# Project Workflow for Contracts Data Cleaning and Transformation

This document outlines the complete workflow for cleaning, transforming, and analyzing the `contracts` dataset. It includes detailed steps, tools, and processes to ensure the data is accurate, consistent, and ready for meaningful analysis.

---

## **1. Project Overview**
The goal of this project is to clean and transform the `contracts` dataset from the City of Austin Contracts Database to prepare it for analysis. The workflow ensures:
- Data accuracy and consistency.
- Standardization of formats and removal of anomalies.
- Performance optimization for queries.
- Enrichment with derived fields and insights for reporting.

---

## **2. Workflow Steps**

### **Step 1: Data Import**
- **Objective**: Import the raw dataset into the database.
- **Tools**: MySQL, Python (optional for file handling).
- **SQL Command**:
  ```sql
  LOAD DATA INFILE '/path/to/contracts.csv'
  INTO TABLE contracts
  FIELDS TERMINATED BY ',' ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  IGNORE 1 ROWS;
  ```
- **Result**: Dataset loaded into the `contracts` table for further processing.

---

### **Step 2: Automated Cleaning**
- **Objective**: Automate the cleaning and transformation process for efficiency and consistency.
- **Actions**:
  - Execute the `automated_cleaning_job.sql` script:
    ```sql
    CALL clean_and_transform_contracts();
    ```
  - This automates:
    - Duplicate removal.
    - Null handling with defaults.
    - Standardization of monetary fields, dates, and phone numbers.
    - Derivation of fields like `contract_size` and `contract_duration`.

---

### **Step 3: Data Validation**
- **Objective**: Validate the dataset to ensure data quality.
- **Key Validation Steps**:
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
   - Ensure derived fields (`contract_size`, `contract_duration`) are correctly populated.

---

### **Step 4: Performance Optimization**
- **Objective**: Improve database performance for efficient querying.
- **Actions**:
  1. **Create Indexes**:
     ```sql
     CREATE UNIQUE INDEX idx_row_key ON contracts(ROW_KEY);
     CREATE INDEX idx_vendor_name ON contracts(LGL_NM);
     CREATE INDEX idx_efbgn_dt ON contracts(EFBGN_DT);
     ```
  2. **Run Optimization Script**:
     - Execute the `performance_optimization.sql` script to rebuild indexes and gather statistics.

---

### **Step 5: Logging and Auditing**
- **Objective**: Maintain traceability for all transformations applied to the `contracts` table.
- **Actions**:
  1. **Track Changes**:
     - Use `audit_logging.sql` to log actions like cleaning and transformations:
       ```sql
       INSERT INTO audit_log (action, table_name, details)
       VALUES ('Data Cleaning', 'contracts', 'Removed duplicates and standardized formats.');
       ```
  2. **Review Logs**:
     ```sql
     SELECT * FROM audit_log;
     ```

---

### **Step 6: Data Analysis**
- **Objective**: Derive insights and generate metrics for reporting.
- **Key Queries**:
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
   GROUP BY YEAR(EFBGN_DT)
   ORDER BY year;
   ```

---

### **Step 7: Data Export**
- **Objective**: Save the cleaned dataset for further visualization or external analysis.
- **Export Script**:
  ```sql
  SELECT *
  INTO OUTFILE '/path/to/exported_cleaned_data.csv'
  FIELDS TERMINATED BY ',' ENCLOSED BY '"'
  LINES TERMINATED BY '\n'
  FROM contracts;
  ```

---

### **8. Documentation**
- **Objective**: Ensure all processes are documented for reproducibility and transparency.
- **Key Documents**:
  1. `README.md`: Project overview and setup instructions.
  2. `transformation_documentation.md`: Details of cleaning and transformation steps.
  3. `validation_results_summary.md`: Summary of validation outcomes.
  4. `analysis_report.md`: Insights and metrics derived from the cleaned dataset.

---

## **3. Tools and Technologies**
- **Database**: MySQL
- **Scripting Language**: SQL, PL/SQL
- **Visualization**: Tableau, Power BI
- **Other Tools**: Python (for optional preprocessing)

---

## **Notes**
- Always validate data at each stage to ensure accuracy.
- Perform optimizations to improve performance before running large queries.
- Maintain detailed logs for all transformations for future traceability.