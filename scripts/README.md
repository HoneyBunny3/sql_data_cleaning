# SQL Scripts Documentation

## Overview
This project includes a suite of SQL scripts to clean, validate, enhance, and analyze the `contracts` dataset.

---

## Execution Workflow

 - Initial Setup: archive_original_data.sql
 - Cleaning: clean_and_standardize_data.sql
 - Transformation: clean_and_enhance_contracts.sql
 - Validation: validate_transformed_data.sql
 - Optimization: create_indexes.sql, performance_optimization.sql
 - Backup and Export: backup_cleaned_data.sql, export_cleaned_data.sql
 - Analysis: analysis_queries.sql

---
## Script Descriptions

### Data Transformation
- `clean_and_standardize_data.sql`: Standardizes data formatting and removes inconsistencies.
- `clean_and_enhance_contracts.sql`: Cleans and enhances the `contracts` table with new columns like `contract_size` and `contract_duration`.
- `validate_transformed_data.sql`: Validates the transformed data for anomalies.

### Automation
- `automated_cleaning_job.sql`: Automates the cleaning process via a scheduled job.
- `data_migration.sql`: Migrates data from a staging table to the production table.
- `data_rollback.sql`: Restores the `contracts` table to its original state using a backup.

### Backup and Archiving
- `archive_original_data.sql`: Archives the original uncleaned data.
- `backup_cleaned_data.sql`: Creates a backup of the cleaned data.

### Performance Optimization
- `create_indexes.sql`: Adds indexes to optimize query performance.
- `performance_optimization.sql`: Gathers statistics and rebuilds indexes for performance optimization.

### Data Export and Analysis
- `export_cleaned_data.sql`: Exports cleaned data to a CSV file.
- `analysis_queries.sql`: Generates reports and insights from the `contracts` dataset.

### Logging and Auditing
- `audit_logging.sql`: Logs changes made to the `contracts` table for traceability.

---

## How to Use
1. Clone the repository and navigate to the `scripts` folder.
2. Follow the execution instructions in each script.
3. Run the scripts in sequence or as needed based on your requirements.

---

## Additional Notes
- **Data Validation**: Run validation scripts periodically to ensure data quality.
- **Automation**: Automate cleaning and migration jobs for regular maintenance.
- **Auditing**: Use the `audit_log` table to track changes.

---

## List of Scripts
| Script Name                       | Description                                                                    |
|-----------------------------------|--------------------------------------------------------------------------------|
| `analysis_queries.sql`            | Generates reports and insights from the contracts data.                        |
| `archive_original_data.sql`       | Archives the original uncleaned data.                                          |
| `automated_cleaning_job.sql`      | Automates the cleaning process.                                                |
| `backup_cleaned_data.sql`         | Creates a backup of the cleaned data.                                          |
| `clean_and_enhance_contracts.sql` | Cleans and enhances the contracts table.                                       |
| `clean_and_standardize_data.sql`  | Standardizes data formatting and removes inconsistencies.                      |
| `create_indexes.sql`              | Adds indexes to optimize database performance.                                 |
| `data_migration.sql`              | Migrates data from a staging table to the production contracts table.          |
| `data_rollback.sql`               | Restores the contracts table from a backup.                                    |
| `performance_optimization.sql`    | Optimizes database performance by rebuilding indexes and gathering statistics. |
| `audit_logging.sql`               | Logs changes made to the contracts table for traceability.                     |
| `export_cleaned_data.sql`         | Exports cleaned data to an external CSV file.                                  |
| `validate_transformed_data.sql`   | Validates the transformed data for anomalies.                                  |