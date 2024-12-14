# Transformation Documentation

## Overview
This document details the transformations and enhancements applied to the `contracts` dataset. The goal is to prepare the data for analysis, reporting, and optimized performance while ensuring accuracy, consistency, and reliability.

---

## **Key Transformations**

### 1. **Duplicate Removal**
- **Objective**: Ensure each row in the dataset is unique.
- **Action**: Retained only the first occurrence of each `ROW_KEY`.
- **SQL Logic**:
  ```sql
  DELETE FROM contracts
  WHERE ROWID NOT IN (
    SELECT MIN(ROWID) FROM contracts
    GROUP BY ROW_KEY
  );
  ```

---

### 2. **Null Handling**
- **Objective**: Replace missing values with meaningful defaults.
- **Action**:
  - Replaced missing values in key fields:
    - `CONTRACT_SYNOPSIS`: `'Not Available'`
    - `ALIAS_NM`: `'No Alias'`
    - Contact fields (`CONTRACT_CONTACT_NM`, `CONTRACT_CONTACT_VOICE_PH_NO`, `CONTRACT_CONTACT_EMAIL_AD`): `'Unknown'`

---

### 3. **Standardization**
- **Objective**: Ensure uniformity across the dataset for text, dates, and phone numbers.
- **Actions**:
  - **Dates**:
    - Converted all date fields (`EFBGN_DT`, `EFEND_DT`, `BRD_AWD_DT`) to `YYYY-MM-DD` format.
    - Replaced invalid or missing dates with `'1900-01-01'`.
    ```sql
    UPDATE contracts
    SET EFBGN_DT = '1900-01-01'
    WHERE EFBGN_DT IS NULL OR EFBGN_DT < '1900-01-01';
    ```
  - **Text Fields**:
    - Standardized contractor and vendor names (`LGL_NM`, `ALIAS_NM`) to uppercase.
    - Trimmed whitespace from text fields.
  - **Phone Numbers**:
    - Normalized phone numbers to `(XXX) XXX-XXXX` format using regular expressions.
    ```sql
    UPDATE contracts
    SET CONTRACT_CONTACT_VOICE_PH_NO = REGEXP_REPLACE(CONTRACT_CONTACT_VOICE_PH_NO, '[^0-9]', '')
    WHERE CONTRACT_CONTACT_VOICE_PH_NO IS NOT NULL;
    ```

---

### 4. **Monetary Validation**
- **Objective**: Ensure monetary fields contain only non-negative values.
- **Action**:
  - Replaced negative values in `MA_PRCH_LMT_AM`, `MA_ITD_ORD_AM`, and `MA_DO_RFED_AM` with `0`.
  ```sql
  UPDATE contracts
  SET MA_PRCH_LMT_AM = 0
  WHERE MA_PRCH_LMT_AM < 0;
  ```

---

### 5. **New Columns Added**
- **Objective**: Enhance the dataset with derived fields.
- **Actions**:
  - **`contract_size`**:
    - Categorized contracts as:
      - "Minor" (`MA_PRCH_LMT_AM < 100,000`)
      - "Major" (`MA_PRCH_LMT_AM >= 100,000`)
    ```sql
    ALTER TABLE contracts
    ADD COLUMN contract_size VARCHAR(10) AS (
      CASE
        WHEN MA_PRCH_LMT_AM < 100000 THEN 'Minor'
        ELSE 'Major'
      END
    );
    ```
  - **`contract_duration`**:
    - Calculated the duration of each contract in days (`EFEND_DT - EFBGN_DT`).
    ```sql
    ALTER TABLE contracts
    ADD COLUMN contract_duration INT AS (DATEDIFF(EFEND_DT, EFBGN_DT));
    ```
  - **`potential_issue`**:
    - Flagged contracts with unusually high spending (`MA_PRCH_LMT_AM > 10,000,000`).
    ```sql
    ALTER TABLE contracts
    ADD COLUMN potential_issue BOOLEAN AS (
      MA_PRCH_LMT_AM > 10000000
    );
    ```

---

### 6. **Category Normalization**
- **Objective**: Ensure consistency in contract categories.
- **Action**: Standardized `CAT_DSCR` values using mapping rules.
- **Example**:
  - `'Construction'` → `'CONSTRUCTION'`
  - `'Other Contracting'` → `'OTHER'`

---

### 7. **Indexing for Performance**
- **Objective**: Optimize the database for frequent queries.
- **Actions**:
  - Created a unique index on `ROW_KEY`.
  - Added standard indexes for commonly queried fields (`LGL_NM`, `EFBGN_DT`).
  ```sql
  CREATE UNIQUE INDEX idx_row_key ON contracts(ROW_KEY);
  CREATE INDEX idx_vendor_name ON contracts(LGL_NM);
  CREATE INDEX idx_efbgn_dt ON contracts(EFBGN_DT);
  ```

---

### 8. **Validation**
- **Objective**: Ensure the dataset meets quality standards after transformation.
- **Checks Performed**:
  - Null values in mandatory fields.
  - Duplicate rows based on `ROW_KEY`.
  - Negative monetary values.
  - Validation of derived fields (`contract_size`, `contract_duration`, `potential_issue`).

---

## **Schema Changes**
| **Column Name**     | **Type**     | **Description**                             |
|---------------------|--------------|---------------------------------------------|
| `contract_size`     | `VARCHAR(10)`| Categorizes contracts as "Minor" or "Major."|
| `contract_duration` | `INT`        | Duration of the contract in days.           |
| `potential_issue`   | `BOOLEAN`    | Flags contracts with potential data issues. |

---

## **Automation and Optimization**

### 1. **Automated Cleaning Process**
- **Objective**: Automate repetitive cleaning tasks for consistency.
- **Implementation**:
  - Cleaning and transformation are automated via the `clean_and_transform_contracts` stored procedure.
  - Can be executed manually or scheduled as part of a job.
  ```sql
  CALL clean_and_transform_contracts();
  ```

### 2. **Audit Logging**
- **Objective**: Maintain traceability for all changes applied to the dataset.
- **Implementation**:
  - All changes are logged into an `audit_log` table.
  - Example:
    ```sql
    INSERT INTO audit_log (action, table_name, details)
    VALUES ('Data Cleaning', 'contracts', 'Removed duplicates and standardized text fields.');
    ```

### 3. **Performance Optimization**
- **Objective**: Ensure efficient query execution.
- **Implementation**:
  - Indexes are rebuilt, and statistics are gathered periodically using the `performance_optimization.sql` script.

---

## **Additional Notes**
- **Backup Strategy**:
  - Original uncleaned data is archived in the `original_contracts` table.
  - Cleaned data is backed up in the `cleaned_contracts` table.
- **Validation Reports**:
  - Validation scripts ensure the data meets expected quality standards.
- **Future Enhancements**:
  - Expand the dataset with additional derived metrics like average contract value per vendor.
  - Integrate validation results directly into reporting dashboards.