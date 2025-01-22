{% macro pivot_json(source_schema, source_table, seed_name) %}

{%- set seed_ref = seed_name -%}
{%- set cols = dbt_utils.get_column_values(table=seed_ref, column='column_name', order_by='min(index)') -%}

WITH records AS ( --Unnest each row (array) into individual elements
    SELECT 
        row_number() OVER () AS record_id, 
        unnest(json) AS element,
        generate_subscripts(json, 1) AS subscript
    FROM read_json({{ source(source_schema, source_table) }})
)
, headers AS ( --Separate headers and add row numbers
    SELECT
        element AS header,
        subscript
    FROM records
    WHERE record_id = 1
)
, data_rows AS ( --Extract data rows (remaining rows) and add row numbers
    SELECT 
        record_id,
        element,
        subscript
    FROM records
    WHERE record_id != 1
    ORDER BY record_id, subscript
)
, joined_data AS (
   -- Join headers with data rows by subscript
    SELECT 
        d.record_id,
        d.subscript AS record_row_num,
        h.subscript AS header_row_num,
        h.header,
        d.element
    FROM data_rows d
    JOIN headers h
        ON d.subscript = h.subscript
    ORDER BY d.record_id, d.subscript
)
PIVOT joined_data
ON header in (
    {% for col in cols %}{{col}}{%- if not loop.last %},{% endif %}
    {%- endfor %}
    )
USING max(element)
GROUP BY record_id
ORDER BY record_id
{%- endmacro %}