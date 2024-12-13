# Transformation Documentation

## Overview
This document describes the transformations and enhancements applied to the `contracts` dataset to prepare it for analysis, reporting, and optimized performance.

## Key Transformations
1. **Duplicate Removal**:
   - Ensured each row is unique by retaining only the first occurrence of `ROW_KEY`.

2. **Null Handling**:
   - Replaced missing values with default placeholders for:
     - `CONTRACT_SYNOPSIS` → `'Not Available'`
     - `ALIAS_NM` → `'No Alias'`
     - Contact fields such as `CONTRACT_CONTACT_NM`, `CONTRACT_CONTACT_VOICE_PH_NO`, and `CONTRACT_CONTACT_EMAIL_AD` → `'Unknown'`

3. **Standardization**:
   - **Dates**:
     - Converted date fields (`EFBGN_DT`, `EFEND_DT`, `BRD_AWD_DT`) to `YYYY-MM-DD` format.
     - Replaced invalid or missing dates with `'1900-01-01'`.
   - **Text Fields**:
     - Standardized vendor and contractor names (`LGL_NM`, `ALIAS_NM`) to uppercase.
     - Trimmed unnecessary whitespace.
   - **Phone Numbers**:
     - Normalized phone numbers to `(XXX) XXX-XXXX` format.

4. **Monetary Validation**:
   - Replaced negative values in monetary fields (`MA_PRCH_LMT_AM`, `MA_ITD_ORD_AM`) with `0`.

5. **New Columns Added**:
   - **`contract_size`**:
     - Categorizes contracts as "Minor" (`MA_PRCH_LMT_AM < 100,000`) or "Major."
   - **`contract_duration`**:
     - Calculates the duration of contracts in days (`EFEND_DT - EFBGN_DT`).
   - **`potential_issue`**:
     - Flags contracts with unusually high spending (`MA_PRCH_LMT_AM > 10,000,000`).

6. **Category Normalization**:
   - Standardized values in `CAT_DSCR` for consistency:
     - Example: `'Construction'` and `'Other Contracting'`.

7. **Indexing for Performance**:
   - Created indexes to optimize common queries:
     - Unique index on `ROW_KEY`.
     - Standard index on `LGL_NM` for vendor queries.
     - Standard index on `EFBGN_DT` for date-based queries.

8. **Validation**:
   - Checked for:
     - Remaining null values.
     - Duplicate rows.
     - Negative monetary values.

## Schema Changes
| Column Name         | Type       | Description                                  |
|---------------------|------------|----------------------------------------------|
| `contract_size`     | VARCHAR(10)| Categorizes contracts as "Minor" or "Major." |
| `contract_duration` | INT        | Duration of the contract in days.            |
| `potential_issue`   | BOOLEAN    | Flags contracts with potential data issues.  |

## Automation and Optimization
1. **Automated Cleaning Process**:
   - Cleaning and transformation are automated via the `clean_and_transform_contracts` procedure.
   - Can be executed as part of a scheduled job.

2. **Audit Logging**:
   - All changes are logged into an `audit_log` table for traceability.

3. **Performance Optimization**:
   - Indexes are rebuilt, and table statistics are gathered regularly for optimized query performance.

## Additional Notes
- **Backup Strategy**:
  - The original uncleaned data is archived in the `original_contracts` table.
  - Cleaned data is backed up in the `cleaned_contracts` table.
- **Validation Reports**:
  - Validation scripts ensure that transformed data meets expected quality standards.