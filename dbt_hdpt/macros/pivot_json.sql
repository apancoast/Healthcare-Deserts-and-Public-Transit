{% macro pivot_json(source_schema, source_table) %}
WITH records AS ( --Unnest each row (array) into individual elements
    SELECT 
        row_number() OVER () AS record_id, 
        unnest(json) AS element
    FROM {{ source(source_schema, source_table) }}
)
, headers AS ( --Separate headers and add row numbers
    SELECT
        element AS header,
        row_number() OVER () AS row_num
    FROM records
    WHERE record_id = 1
)
, data_rows AS ( --Extract data rows (remaining rows) and add row numbers
    SELECT 
        *,
        row_number() OVER (PARTITION BY record_id ORDER BY record_id) AS row_num
    FROM records
    WHERE record_id != 1
)
, joined_data AS (
    SELECT 
        d.record_id,
        h.header,
        d.element
    FROM data_rows d
    JOIN headers h
        ON d.row_num = h.row_num -- Match data rows with headers by row number
    ORDER BY d.record_id, d.row_num
)
PIVOT joined_data
ON header 
USING max(element)
GROUP BY record_id
ORDER BY record_id
{% endmacro %}