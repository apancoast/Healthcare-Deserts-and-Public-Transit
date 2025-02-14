{%- set seed_ref = ref('seed_cms__clinicians_facilities__data_catalog') -%}

{%- set cols = dbt_utils.get_column_values(table=seed_ref, column='raw_column_name', order_by='min(stage_index)') -%}
{%- set as_cols = dbt_utils.get_column_values(table=seed_ref, column='stage_column_name', order_by='min(stage_index)') -%}
{%- set data_types = get_col_values_from_query(table=seed_ref, column='data_type') -%}

{%- set zips = dbt_utils.get_column_values(table=ref('seed__meck_co_zip_codes'), column='zip') -%}

with source as (
        select
            *
        from read_csv({{ source('census_bureau', 'doc') }})
  )
select 
    {%- for index in range(0, cols|length) %}
    {# "{{ cols[index] }}" as {{ as_cols[index] }} #}
    {%- if data_types[index] == 'string' -%}
        trim(upper("{{ cols[index] }}"::varchar)) as {{ as_cols[index] }}
    {%- else -%}
        "{{ cols[index] }}" as {{ as_cols[index] }}
    {%- endif -%}
    {%- if not loop.last -%},{% endif %}
    {%- endfor %}
from source
where left("ZIP Code"::varchar, 5) in (
    {%- for zip in zips %}
    {{ zip }}{%- if not loop.last -%},{% endif %}
    {%- endfor %}
    )