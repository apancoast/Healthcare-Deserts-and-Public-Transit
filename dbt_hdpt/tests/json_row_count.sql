{% test json_row_count(source_name, table_name, pivot_model_name) %}

WITH source_data AS (
    SELECT json
    FROM {{ source(source_name, table_name) }}
),
expected_count AS (
    SELECT array_length(json) - 1 AS expected_row_count
    FROM source_data
    LIMIT 1
),
actual_count AS (
    SELECT COUNT(*) AS actual_row_count
    FROM {{ ref(pivot_model_name) }}
)
SELECT 
    CASE 
        WHEN actual_count.actual_row_count = expected_count.expected_row_count THEN 1
        ELSE 0
    END AS test_passed
FROM expected_count, actual_count;

{% endtest %}
