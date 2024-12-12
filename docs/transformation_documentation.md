# Transformation Documentation

## Overview
This document describes the transformations applied to the `contracts` dataset to prepare it for analysis and reporting.

## Key Transformations
1. **Duplicate Removal**:
   - Ensured each row is unique by retaining only the first occurrence of `ROW_KEY`.

2. **Null Handling**:
   - Replaced missing values with default placeholders for `CONTRACT_SYNOPSIS`, `ALIAS_NM`, and contact fields.

3. **Standardization**:
   - Dates converted to `YYYY-MM-DD` format.
   - Vendor and contractor names standardized to uppercase.

4. **New Columns**:
   - **`contract_size`**: Categorizes contracts as "Minor" or "Major."
   - **`contract_duration`**: Calculates the duration of contracts in days.

5. **Issue Flagging**:
   - Identified contracts with unusually high spending for manual review.

## Schema Changes
| Column Name         | Type       | Description                                  |
|---------------------|------------|----------------------------------------------|
| `contract_size`     | VARCHAR(10)| Categorizes contracts as "Minor" or "Major." |
| `contract_duration` | INT        | Duration of the contract in days.            |
| `potential_issue`   | BOOLEAN    | Flags contracts with potential data issues.  |