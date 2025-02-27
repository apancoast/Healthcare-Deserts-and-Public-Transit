{%- test row_count_equal_to_source_file(source_name, table_name, model, where_clause=None) -%}

{%- set compiled_source = source(source_name, table_name) | string -%}
{%- set file_extension = compiled_source.split('.')[-1] | replace("'", "") | lower -%}

{% do run_query("LOAD spatial;") %}

{%- if file_extension == 'json' -%}
    {% set read_function = 'read_json' %}
    {% set count_expression = 'SELECT count(*) - 1 AS expected_row_count FROM ' + read_function + '(' + compiled_source + ')' %}
{%- elif file_extension in ['csv', 'txt'] -%}
    {% set read_function = 'read_csv' %}
    {% set count_expression = 'SELECT count(*) AS expected_row_count FROM ' + read_function + '(' + compiled_source + ')' %}
{%- elif file_extension == 'shp' -%}
    {% set read_function = 'ST_read' %}
    {% set count_expression = 'SELECT count(*) AS expected_row_count FROM ' + read_function + '(' + compiled_source + ')' %}
{%- else -%}
    {% set count_expression = 'SELECT count(*) AS expected_row_count FROM ' + compiled_source %}
{%- endif -%}

{%- if where_clause -%}
    {% set count_expression = count_expression + ' WHERE ' + where_clause %}
{%- endif -%}

{%- if file_extension == 'shp' -%}
    {% do run_query("LOAD spatial;") %}
{%- endif -%}

WITH expected_count AS (
    {{ count_expression }}
),
actual_count AS (
    SELECT COUNT(*) AS actual_row_count
    FROM {{ model }}
)
SELECT 
    *
FROM expected_count, actual_count
WHERE actual_row_count <> expected_row_count

{%- endtest -%}
