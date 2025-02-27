## Data Profiling and Discovery
Data profiling and validation at the staging models layer is limited to structural validation. I am choosing to postpone content and relationship (for cross-source relationships) validation for the intermediate models.

### Discovery
Schema and data type discovery was done through gathering of source's metadata on the datasets, and documented in Data Catalogs used as dbt seed files.

---
## Validation Tests & Implementation

### Testing Strategy

| Validation Method                      | Tool Used                                                                                                                                                                                                              |
| -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Data Types                             | data_test from dbt Expectations package: [expect_column_values_to_be_of_type](https://github.com/calogica/dbt-expectations/blob/0.10.4/macros/schema_tests/column_values_basic/expect_column_values_to_be_of_type.sql) |
| Redundancy by way of column selection  | data_test from dbt Expectations package: [expect_table_columns_to_contain_set](https://github.com/calogica/dbt-expectations/tree/0.10.4/?tab=readme-ov-file#expect_table_columns_to_contain_set)                       |
| Record counts                          | custom data_test: row_count_equal_to_source_file                                                                                                                                                                       |
| Referential integrity (within sources) | dbt data_test: relationships                                                                                                                                                                                           |
| Uniqueness                             | dbt data_test: unique                                                                                                                                                                                                  |
| Completeness                           | dbt data_test: not_null                                                                                                                                                                                                |

### Test's Documentation
Details of tests are documented through dbt docs:
- Table and column level tests can be found in the staging model's ymls.
- Description of macro tests used can be found in the macros/tests.yml.
---
## Monitoring
**Alerts Used:**
-  Zero tolerance threshold: dbt models will fail to build if tests fail