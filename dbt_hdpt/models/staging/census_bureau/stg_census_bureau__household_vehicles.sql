{%- set seed_ref = ref('seed_census_bureau__dp04_metadata') %}

{%- set cols = dbt_utils.get_column_values(table=seed_ref, column='column_name', order_by='min(index)') %}
{%- set as_cols = dbt_utils.get_column_values(table=seed_ref, column='new_label', order_by='min(index)') %}
{%- set data_types = get_col_values_from_query(table=seed_ref, column='data_type') %}

with pivoted_data as (
    {{ pivot_json('census_bureau', 'dp04', seed_ref) }}
    )
select
    {%- for index in range(0, cols|length) %}
    {{ cols[index] }}::{{ data_types[index] }} as {{ as_cols[index] }}{%- if not loop.last -%},{% endif %}
    {%- endfor %}
from pivoted_data