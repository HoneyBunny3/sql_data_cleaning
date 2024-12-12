# Data Dictionary for Contracts Dataset

This data dictionary describes the fields in the contracts dataset and their intended meanings. Each column in the dataset is documented with a description of its content.

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

## Notes
- **Missing Data**: Columns like `CONTRACT_SYNOPSIS` and `ALIAS_NM` have many missing values and may need to be replaced with default placeholders.
- **Monetary Fields**: Ensure that fields like `MA_PRCH_LMT_AM`, `MA_ITD_ORD_AM`, and `MA_DO_RFED_AM` are validated for positive values.
- **Date Fields**: Fields like `EFBGN_DT`, `EFEND_DT`, and `BRD_AWD_DT` should be standardized to `YYYY-MM-DD` format for consistency.

## Future Enhancements
- Add documentation for any derived or calculated fields created during the cleaning or analysis process.
- Include visual examples of cleaned data fields where applicable.