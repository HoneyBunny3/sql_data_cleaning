# SQL Scripts for Data Cleaning and Transformation

## Overview
This directory contains SQL scripts for cleaning, transforming, validating, and optimizing the `contracts` data in your database. Each script has been designed for a specific purpose within the data pipeline, ensuring robust data quality and performance.

---

## Recommended Workflow
1. Archive original data: `archive_original_data.sql` (optional).
2. Clean and standardize data: `clean_and_standardize_data.sql`.
3. Validate cleaned data: `validate_transformed_data.sql`.
4. (Optional) Enhance data: `clean_and_enhance_contracts.sql`.
5. Backup cleaned data: `backup_cleaned_data.sql` (optional).
6. Optimize performance: `create_indexes.sql` and `performance_optimization.sql`.
7. Generate insights or export data: `analysis_queries.sql` or `export_cleaned_data.sql`.

---

## Scripts Breakdown and Usage

### **Data Cleaning and Transformation**
1. **`clean_and_standardize_data.sql`**
   - **Purpose**: Cleans and standardizes the raw `contracts` table by:
     - Removing duplicates.
     - Standardizing formats (e.g., dates, text fields).
     - Fixing common data errors.
   - **Execution Order**: Run first in the cleaning workflow.
   - **When to Use**: Essential for initial data cleaning.

2. **`validate_transformed_data.sql`**
   - **Purpose**: Validates the cleaned data to ensure:
     - No NULL values in mandatory fields.
     - Unique constraints are enforced.
     - Data conforms to expected formats.
   - **Execution Order**: Run after `clean_and_standardize_data.sql`.
   - **When to Use**: Ensures data quality before further processing.

3. **`clean_and_enhance_contracts.sql`**
   - **Purpose**: Enhances the cleaned data by:
     - Adding calculated fields (e.g., contract durations).
     - Joining with other tables for additional context.
   - **Execution Order**: Run after validation.
   - **When to Use**: Use only if additional enhancements are needed.

---

### **Support and Maintenance**
4. **`archive_original_data.sql`**
   - **Purpose**: Archives raw, uncleaned data into a backup table (`original_contracts`) for traceability.
   - **Execution Order**: Run before cleaning scripts.
   - **When to Use**: Recommended if retaining the original data is important.

5. **`backup_cleaned_data.sql`**
   - **Purpose**: Creates a backup of the cleaned data for safekeeping.
   - **Execution Order**: Run after validation and before transformations or migrations.
   - **When to Use**: Optional, but useful for recovery purposes.

6. **`data_migration.sql`**
   - **Purpose**: Migrates cleaned and transformed data from staging to production tables.
   - **Execution Order**: Run after all cleaning and transformation is complete.
   - **When to Use**: For final deployment of cleaned data.

7. **`data_rollback.sql`**
   - **Purpose**: Restores the `contracts` table to its original state using archived data.
   - **Execution Order**: Run only if a rollback is required.
   - **When to Use**: For recovery in case of cleaning or transformation issues.

---

### **Optimization and Automation**
8. **`create_indexes.sql`**
   - **Purpose**: Creates indexes to optimize query performance on frequently used fields.
   - **Execution Order**: Run after data cleaning and validation.
   - **When to Use**: Improves performance for reporting and queries.

9. **`performance_optimization.sql`**
   - **Purpose**: Rebuilds indexes and gathers statistics to optimize database performance.
   - **Execution Order**: Run periodically or after major changes to data.
   - **When to Use**: For performance maintenance.

10. **`automated_cleaning_job.sql`**
    - **Purpose**: Automates the cleaning process by scheduling the `clean_and_transform_contracts` procedure.
    - **Execution Order**: Configure for ongoing automated cleaning.
    - **When to Use**: For production environments requiring recurring data cleaning.

---

### **Reporting and Exports**
11. **`analysis_queries.sql`**
    - **Purpose**: Provides insights into the cleaned data, including trends and statistics.
    - **Execution Order**: Run after cleaning and transformation.
    - **When to Use**: For analysis and reporting purposes.

12. **`export_cleaned_data.sql`**
    - **Purpose**: Exports cleaned data from the `contracts` table to a CSV file for external use.
    - **Execution Order**: Run after cleaning and validation.
    - **When to Use**: When cleaned data needs to be shared or archived externally.

---

## Notes
- Scripts are designed for modular use; adjust the workflow based on your project needs.
- Always test scripts on a staging environment before deploying to production.
- Refer to the main project [README](../README.md) for more details on setting up your environment.