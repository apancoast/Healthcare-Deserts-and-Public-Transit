with source as (
        select
            *
        from read_csv({{ source('gtfs', 'calendar_dates') }}, types = {'date': 'string'})
  )
select 
    service_id
    , (SUBSTR("date", 1, 4)||'-'||SUBSTR("date", 5, 2)||'-'||SUBSTR("date", 7, 2))::DATE AS service_date
    , exception_type
    , CASE
        WHEN exception_type = 1 then 'service added'
        WHEN exception_type = 2 then 'service removed'
        ELSE null
    END as exception_type_desc
from source
    
