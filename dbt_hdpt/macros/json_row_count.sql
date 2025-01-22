{% test json_row_count(source_name, table_name, model) %}
WITH expected_count AS (
    SELECT count(*) - 1 AS expected_row_count
    FROM read_json({{ source(source_name, table_name) }})
),
actual_count AS (
    SELECT COUNT(*) AS actual_row_count
    FROM {{ model }}
)
SELECT 
    *
FROM expected_count, actual_count
where actual_row_count <> expected_row_count
{% endtest %}