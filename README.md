# SQL Data Cleaning

This repository showcases my skills in cleaning and transforming data using SQL. The project features a dataset sourced from the **Federal Procurement Data System (FPDS)** and demonstrates how enterprise-level data issues are addressed using SQL scripting.

## Objective
To clean and prepare raw contract data for meaningful analysis and reporting, highlighting my ability to manage and process large datasets with a focus on minor and major contract reporting.

## Dataset
- **Source**: [Federal Procurement Data System (FPDS)](https://sam.gov/data-bank)
- **Description**: The dataset contains federal contract data, including contractor names, contract values, project descriptions, and timelines.
- **Scope**: Focused on construction-related contracts to align with industry-specific reporting needs.

## Key Features
1. **Data Cleaning**:
   - Removed duplicates and ensured data integrity.
   - Standardized text fields (e.g., contractor names) and formatted numeric fields.
   - Replaced missing values with appropriate defaults.

2. **Data Transformation**:
   - Categorized contracts into "minor" and "major" based on their value.
   - Extracted key metrics such as total spending and contract counts.
   - Validated and enforced data consistency (e.g., no negative values).

3. **Reporting**:
   - Generated insights such as spending trends and contractor performance.
   - Prepared the data for visualization in Tableau and Power BI.

## SQL Scripts
The repository includes:
- `cleaning.sql`: Scripts for cleaning and standardizing the data.
- `transformation.sql`: Scripts for transforming data to derive insights.
- `analysis.sql`: Queries for generating reports and exporting results.

## Example Queries
### Remove Duplicates
```sql
DELETE FROM contracts
WHERE id NOT IN (
    SELECT MIN(id)
    FROM contracts
    GROUP BY contract_id
);
```
Standardize Contractor Names
```sql
UPDATE contracts
SET contractor_name = UPPER(contractor_name);
```

Categorize Contracts by Value
```sql
SELECT
    CASE
        WHEN contract_value < 100000 THEN 'Minor'
        ELSE 'Major'
    END AS contract_type,
    COUNT(*) AS contract_count,
    SUM(contract_value) AS total_spent
FROM contracts
GROUP BY contract_type;
```

Visualizations

Although this repository focuses on SQL, cleaned and transformed data can be used to create dashboards in tools like Tableau and Power BI. Example visualizations include:

    Contract Spending Trends
    Top Contractors by Value
    Minor vs. Major Contract Distribution

How to Use

    Clone this repository:

    git clone https://github.com/your-username/sql_data_cleaning.git

    Import the SQL scripts into your database environment.
    Execute the scripts step-by-step as outlined in the documentation.

Tools & Technologies

    Database: MySQL
    Languages: SQL
    Visualization: Tableau, Power BI (data prepared for use)

License

This project is licensed under the MIT License. See the LICENSE file for details.

Feel free to explore the scripts and adapt them to your datasets. Feedback and contributions are welcome!