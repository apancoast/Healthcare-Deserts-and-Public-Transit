# Health Professional Shortage Areas
## Overview
**Purpose**: This table selects desired variables from the spatial data file for Primary Care Geographic and Population HPSAs source that are relevant for downstream analysis. Contains one record for each designation census tract in Mecklenburg County, North Carolina.

## Source Dataset
### Source Details
- **Source Name**: `Area HPSA Component Boundaries – SHP for Health Professional Shortage Areas – Primary Care from the Health Resources & Services Administration.`
- **Accessed Via**: `Direct download`
- **Accessed From**: `https://data.hrsa.gov/data/download. Direct link: https://data.hrsa.gov//DataDownload/DD_Files/HPSA_CMPPC_SHP.zip`  
- **Accessed Date**: `2025-01-10`   
- **Storage Location**: `S3://hdpt/raw/HPSA_CMPPC_SHP.zip`
- **File Name(s)/Format(s)**:
    - Data Dictionary.xlsx
    - HPSA_CMPPC_SHP_DET_CUR_VX.shp

---

## Data Schema         <!-- I believe this is in the yml, but maybe I want to use this source as docs source? -->
### Table Name
`stg_census_bureau__public_insurance`

### Columns
| Column Name       | Data Type  | Description                        |
|-------------------|------------|------------------------------------|
| `<column_name>`   | `<type>`   | Brief description of the column.  |
| `<column_name>`   | `<type>`   | Brief description of the column.  |

_Instructions_:  
- Replace `<column_name>` with the actual column name.  
- Use clear, concise descriptions that highlight the purpose of each column.  
- Include primary keys, unique constraints, or other metadata where applicable.

---
### Transformation Context
**Initial Transformations**: Transformations applied to raw data before staging.
1. Parsed JSON arrays and pivoted to fit relational table format.
2. Selected 104 attributes out of 350 based on relevance to analysis. Included dropping all "annotation" columns.
3. Renamed columns.
---

## Data Validation
**Tests Applied**: Outline all tests performed to ensure data quality.  
| Test Name              | Description                            | Status    |
|------------------------|----------------------------------------|-----------|
| Column Name Consistency | Ensures all expected columns are present. | ✅ Pass  |
| Null Value Check        | Verifies that no critical columns contain nulls. | ✅ Pass  |
| Row Count Comparison    | Confirms row counts match the source dataset. | ✅ Pass  |

_Instructions_:  
- Include test names, descriptions, and results.  
- Add any additional tests or validation scripts used.  

---

## Notes and Known Issues
**General Notes**: Include any observations or decisions made during the creation of this table.  
_Example_: "Array unnesting required manual ordering due to inconsistent JSON field placement."  

**Known Issues**: List any limitations or unresolved issues.  
_Example_:  
- "Pivot macro assumes consistent JSON structure; updates may cause errors."  
- "Some columns have sparse data that may need additional imputation in downstream models."  

---

## Updates Log
| Date       | Change Description                             | Changed By    |
|------------|-----------------------------------------------|---------------|
| YYYY-MM-DD | Initial table creation                        | Your Name     |
| YYYY-MM-DD | Added new column `median_income`              | Your Name     |
| YYYY-MM-DD | Updated data validation to include row checks | Your Name     |

---

**Instructions for Use**:  
1. Replace placeholders (e.g., `<...>`) with actual information.  
2. Maintain consistent formatting for all staging table documentation.  
3. Link this document to dbt models or project management tools as needed.


---
# DP04
## Overview
**Purpose**: This table selects desired variables from the source that are relevant for downstream analysis. Contains estimated totals and percentages of housing tenure, household size, and count of vehicles available to household for Census Blocks in Mecklenburg County, North Carolina.

## Source Dataset
### Source Details
- **Source Name**: `U.S. Census Bureau, 2019-2023 American Community Survey 5-Year Estimates`
- **Source Table**: `DP04: Selected Housing Characteristics`  
- **Accessed From**: `https://api.census.gov/data/2023/acs/acs5/profile?get=group(DP04)&ucgid=pseudo(0500000US37119$1400000)`
- **Access Date**: `2024-12-14`   
- **Storage Location**: `s3://hdpt/raw/census_bureau/`
- **File Name/Format**: `dp04.json`   
---
## Data Schema
### Transformation Context
**Initial Transformations**: Transformations applied to raw data before staging.
1. Parsed JSON arrays and pivoted to fit relational table format.
2. Selected 42 attributes out of 1,146 based on relevance to analysis. Included dropping all "annotation" columns.
3. Renamed columns.