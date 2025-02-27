{%- set seed_ref = ref('seed_hpsa__components_shapefile__data_catalog') -%}

{%- set cols = dbt_utils.get_column_values(table=seed_ref, column='raw_column_name', order_by='min(stage_index)') -%}
{%- set as_cols = dbt_utils.get_column_values(table=seed_ref, column='stage_column_name', order_by='min(stage_index)') -%}
{%- do run_query("LOAD spatial;") -%}

with source as (
        select * from ST_read({{ source('hpsa', 'HPSA_CMPPC_SHP_DET_CUR_VX') }})
        where CStAbbr ='NC'
          and CntNM = 'Mecklenburg'
  )
select
    {%- for index in range(0, cols|length) %}
    {{ cols[index] }} as {{ as_cols[index] }}{%- if not loop.last -%},{% endif %}
    {%- endfor %}
from source