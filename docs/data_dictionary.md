# Data Dictionary for Contracts Dataset

This data dictionary describes the fields in the contracts dataset and their intended meanings. Each column in the dataset is documented with a description of its content, including derived fields added during data transformation.

---

## **Original Fields**

| **Column Name**                | **Description**                                                                    |
|--------------------------------|------------------------------------------------------------------------------------|
| `DOC_CD`                       | Document code identifying the type of document (e.g., Contract, Purchase Order).   |
| `DOC_DEPT_CD`                  | Department code associated with the document.                                      |
| `DOC_ID`                       | Unique identifier for the document.                                                |
| `DOC_VERS_NO`                  | Version number of the document.                                                    |
| `DOC_DSCR`                     | Description of the document, providing details about the contract or purchase.     |
| `CONTRACT_SYNOPSIS`            | Summary of the contract's purpose and scope. Often missing or not provided.        |
| `CONTRACT_CONTACT_NM`          | Name of the contact person for the contract.                                       |
| `CONTRACT_CONTACT_VOICE_PH_NO` | Contact phone number of the contract's representative.                             |
| `CONTRACT_CONTACT_EMAIL_AD`    | Email address of the contact person for the contract.                              |
| `MA_PRCH_LMT_AM`               | Maximum purchase limit amount for the contract.                                    |
| `MA_ITD_ORD_AM`                | Amount ordered to date under the contract.                                         |
| `MA_DO_RFED_AM`                | Amount referenced by direct orders under the contract.                             |
| `EFBGN_DT`                     | Effective begin date of the contract (format: `YYYY-MM-DD`).                       |
| `EFEND_DT`                     | Effective end date of the contract (format: `YYYY-MM-DD`).                         |
| `GNRC_PO_RPT_1`                | Generic purchase order report number (used internally for tracking).               |
| `RPT_DSCR`                     | Description of the report associated with the contract.                            |
| `BRD_AWD_DT`                   | Board award date for the contract (format: `YYYY-MM-DD`).                          |
| `BRD_AWD_NO`                   | Board award number associated with the contract.                                   |
| `CAT_DSCR`                     | Category description, indicating the type of contract (e.g., Construction, Goods). |
| `DOC_VEND_LN_NO`               | Vendor line number within the document.                                            |
| `VEND_CUST_CD`                 | Customer code for the vendor associated with the contract.                         |
| `LGL_NM`                       | Legal name of the contractor or vendor.                                            |
| `ALIAS_NM`                     | Alias or alternative name for the contractor/vendor.                               |
| `SO_DOC_CD`                    | Source document code, identifying the document type that originated this data.     |
| `SO_DOC_DEPT_CD`               | Department code for the source document.                                           |
| `SO_DOC_ID`                    | Unique identifier for the source document.                                         |
| `TODAY`                        | The date when the dataset was generated or updated (format: `YYYY-MM-DD`).         |
| `ROW_KEY`                      | Unique key for identifying each row in the dataset.                                |

---

## **Derived and Added Fields**

| **Column Name**      | **Description**                                                                 |
|-----------------------|---------------------------------------------------------------------------------|
| `contract_size`       | Categorizes contracts as "Minor" (less than $100,000) or "Major" based on `MA_PRCH_LMT_AM`. |
| `contract_duration`   | Calculates the duration of contracts in days using `EFEND_DT` - `EFBGN_DT`.    |
| `potential_issue`     | Flags contracts with potential anomalies, such as spending over $10,000,000.   |

---

## **Data Types**

| **Column Name**                | **Data Type**   | **Notes**                                                                 |
|--------------------------------|-----------------|---------------------------------------------------------------------------|
| `DOC_CD`                       | VARCHAR(20)     | Text-based code for document types.                                       |
| `DOC_ID`                       | VARCHAR(50)     | Unique text-based identifier.                                             |
| `CONTRACT_CONTACT_NM`          | VARCHAR(255)    | Contact names are standardized to uppercase and trimmed.                  |
| `CONTRACT_CONTACT_VOICE_PH_NO` | VARCHAR(20)     | Phone numbers normalized to `(XXX) XXX-XXXX` format.                      |
| `MA_PRCH_LMT_AM`               | DECIMAL(15, 2)  | Validated to ensure non-negative values.                                  |
| `EFBGN_DT`, `EFEND_DT`         | DATE            | Standardized to `YYYY-MM-DD` format. Invalid dates replaced with `1900-01-01`. |
| `contract_size`                | VARCHAR(10)     | Derived field: "Minor" or "Major."                                        |
| `contract_duration`            | INT             | Derived field: Duration in days.                                          |
| `potential_issue`              | BOOLEAN         | Flags contracts with spending anomalies.                                  |

---

## **Validation Rules**

| **Validation Rule**              | **Description**                                                                 |
|----------------------------------|---------------------------------------------------------------------------------|
| Null Values                      | Missing values are replaced with default placeholders.                          |
| Duplicate Rows                   | Removed based on `ROW_KEY` to ensure data uniqueness.                          |
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