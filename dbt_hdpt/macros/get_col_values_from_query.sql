{% macro get_col_values_from_query(table, column, order_by='stage_index') %}
    {%- set sql_statement %}
        SELECT {{ column }} FROM {{ table }} ORDER BY {{ order_by }}
    {%- endset %}

    {%- set results = run_query(sql_statement) %}

    {%- if execute %}
        {% set column_values = results.columns[0].values() %}
    {% else %}
        {% set column_values = [] %}
    {% endif %}

    {{ return(column_values) }}
{% endmacro %}
