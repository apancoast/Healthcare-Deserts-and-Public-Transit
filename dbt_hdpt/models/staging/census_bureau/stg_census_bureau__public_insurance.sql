{%- set seed_ref = ref('seed_census_bureau__public_insurance__data_catalog') %}

{%- set cols = dbt_utils.get_column_values(table=seed_ref, column='raw_column_name', order_by='min(stage_index)') %}
{%- set as_cols = dbt_utils.get_column_values(table=seed_ref, column='stage_column_name', order_by='min(stage_index)') %}
{%- set data_types = get_col_values_from_query(table=seed_ref, column='data_type') %}

with pivoted_data as (
    {{ pivot_json('census_bureau', 's2704', seed_ref) }}
    )
select
    {% for index in range(0, cols|length) %}
    {%- set col_name = cols[index] -%}
    {%- set data_type = data_types[index] -%}
    {%- set as_col = as_cols[index] -%}

    {% if col_name.startswith('S2704') %}
        case 
            when {{ col_name }} like '-%' then null 
            else {{ col_name }} 
        end::{{ data_type }} as {{ as_col }}
    {%- else -%}
        {{ col_name }}::{{ data_type }} as {{ as_col }}
    {%- endif -%}
    
    {%- if not loop.last -%},{% endif %}
    {%- endfor %}
from pivoted_data
