# Data Dictionary for Contracts Dataset

This data dictionary describes the fields in the contracts dataset and their intended meanings. Each column in the dataset is documented with a description of its content, including derived fields added during data transformation.

---

## **Original Fields**

| **Column Name**                | **Description**                                                                    | **Data Type**   | **Example**          |
|--------------------------------|------------------------------------------------------------------------------------|-----------------|----------------------|
| `DOC_CD`                       | Document code identifying the type of document (e.g., Contract, Purchase Order).   | `VARCHAR(20)`   | `CNTRCT`             |
| `DOC_DEPT_CD`                  | Department code associated with the document.                                      | `VARCHAR(10)`   | `FIN`                |
| `DOC_ID`                       | Unique identifier for the document.                                                | `VARCHAR(50)`   | `CNTRCT_20241234`    |
| `DOC_VERS_NO`                  | Version number of the document.                                                    | `INT`           | `1`                  |
| `DOC_DSCR`                     | Description of the document, providing details about the contract or purchase.     | `TEXT`          | `Purchase of goods`  |
| `CONTRACT_SYNOPSIS`            | Summary of the contract's purpose and scope. Often missing or not provided.        | `TEXT`          | `Software purchase`  |
| `CONTRACT_CONTACT_NM`          | Name of the contact person for the contract.                                       | `VARCHAR(255)`  | `Jane Doe`           |
| `CONTRACT_CONTACT_VOICE_PH_NO` | Contact phone number of the contract's representative.                             | `VARCHAR(20)`   | `(512) 555-1234`     |
| `CONTRACT_CONTACT_EMAIL_AD`    | Email address of the contact person for the contract.                              | `VARCHAR(255)`  | `jane.doe@email.com` |
| `MA_PRCH_LMT_AM`               | Maximum purchase limit amount for the contract.                                    | `DECIMAL(15, 2)`| `500000.00`          |
| `MA_ITD_ORD_AM`                | Amount ordered to date under the contract.                                         | `DECIMAL(15, 2)`| `250000.00`          |
| `MA_DO_RFED_AM`                | Amount referenced by direct orders under the contract.                             | `DECIMAL(15, 2)`| `100000.00`          |
| `EFBGN_DT`                     | Effective begin date of the contract (format: `YYYY-MM-DD`).                       | `DATE`          | `2024-01-01`         |
| `EFEND_DT`                     | Effective end date of the contract (format: `YYYY-MM-DD`).                         | `DATE`          | `2025-01-01`         |
| `GNRC_PO_RPT_1`                | Generic purchase order report number (used internally for tracking).               | `VARCHAR(20)`   | `PO12345`            |
| `RPT_DSCR`                     | Description of the report associated with the contract.                            | `TEXT`          | `Annual spend report`|
| `BRD_AWD_DT`                   | Board award date for the contract (format: `YYYY-MM-DD`).                          | `DATE`          | `2024-03-15`         |
| `BRD_AWD_NO`                   | Board award number associated with the contract.                                   | `VARCHAR(20)`   | `BRD202403`          | 
| `CAT_DSCR`                     | Category description, indicating the type of contract (e.g., Construction, Goods). | `VARCHAR(50)`   | `Construction`       |
| `DOC_VEND_LN_NO`               | Vendor line number within the document.                                            | `INT`           | `1`                  |
| `VEND_CUST_CD`                 | Customer code for the vendor associated with the contract.                         | `VARCHAR(50)`   | `VEND12345`          |
| `LGL_NM`                       | Legal name of the contractor or vendor.                                            | `VARCHAR(255)`  | `Acme Corp`          |
| `ALIAS_NM`                     | Alias or alternative name for the contractor/vendor.                               | `VARCHAR(255)`  | `Acme`               |
| `SO_DOC_CD`                    | Source document code, identifying the document type that originated this data.     | `VARCHAR(20)`   | `PO`                 |
| `SO_DOC_DEPT_CD`               | Department code for the source document.                                           | `VARCHAR(10)`   | `HR`                 |
| `SO_DOC_ID`                    | Unique identifier for the source document.                                         | `VARCHAR(50)`   | `SO12345`            |
| `TODAY`                        | The date when the dataset was generated or updated (format: `YYYY-MM-DD`).         | `DATE`          | `2024-12-14`         |
| `ROW_KEY`                      | Unique key for identifying each row in the dataset.                                | `VARCHAR(50)`   | `ROW20241234`        |

---

## **Derived and Added Fields**

| **Column Name**       | **Description**                                                                             | **Data Type**   | **Example**     |
|-----------------------|---------------------------------------------------------------------------------------------|-----------------|-----------------|
| `contract_size`       | Categorizes contracts as "Minor" (less than $100,000) or "Major" based on `MA_PRCH_LMT_AM`. | `VARCHAR(10)`   | `Major`         |
| `contract_duration`   | Calculates the duration of contracts in days using `EFEND_DT` - `EFBGN_DT`.                 | `INT`           | `365`           |
| `potential_issue`     | Flags contracts with potential anomalies, such as spending over $10,000,000.                | `BOOLEAN`       | `TRUE`          |

---

## **Validation Rules**

| **Validation Rule**              | **Description**                                                                 |
|----------------------------------|---------------------------------------------------------------------------------|
| Null Values                      | Missing values are replaced with default placeholders.                          |
| Duplicate Rows                   | Removed based on `ROW_KEY` to ensure data uniqueness.                           |
| Monetary Fields                  | Negative values in `MA_PRCH_LMT_AM` and `MA_ITD_ORD_AM` replaced with `0`.      |
| Date Fields                      | Standardized to `YYYY-MM-DD` and invalid dates replaced with `1900-01-01`.      |
| Phone Numbers                    | Normalized to `(XXX) XXX-XXXX` format.                                          |
| Contract Size Classification     | Categorized as "Minor" or "Major" based on `MA_PRCH_LMT_AM`.                    |
| Potential Data Issues Flagging   | Contracts with spending > $10,000,000 flagged for manual review.                |

---

## **Future Enhancements**
- Document and visualize relationships between fields (e.g., foreign key dependencies).
- Expand with additional derived metrics like average contract value per vendor.
- Include sample rows of the dataset to showcase cleaned and transformed data.

---

## **Notes**
- **Missing Data**: Columns like `CONTRACT_SYNOPSIS` and `ALIAS_NM` had missing values that were replaced during cleaning.
- **Monetary Fields**: Validated to ensure positive values in `MA_PRCH_LMT_AM`, `MA_ITD_ORD_AM`, and `MA_DO_RFED_AM`.
- **Date Fields**: Validated and standardized to ensure consistency across the dataset.