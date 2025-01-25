{%- set seed_ref = ref('seed_hpsa__components_shapefile__data_catalog') %}

{%- set cols = dbt_utils.get_column_values(table=seed_ref, column='column_name', order_by='min(index)') %}
{%- set as_cols = dbt_utils.get_column_values(table=seed_ref, column='new_column_name', order_by='min(index)') %}
{% do run_query("LOAD spatial;") %}

with source as (
        select * from ST_read({{ source('hpsa', 'HPSA_CMPPC_SHP_DET_CUR_VX') }})
  )
select
    {%- for index in range(0, cols|length) %}
    {{ cols[index] }} as {{ as_cols[index] }}{%- if not loop.last -%},{% endif %}
    {%- endfor %}
from source
where CStAbbr ='NC'
and CntNM = 'Mecklenburg'