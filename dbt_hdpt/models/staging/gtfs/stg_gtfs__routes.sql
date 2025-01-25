with source as (
        select * from read_csv({{ source('gtfs', 'routes') }})
  )
select
    route_id,
    route_short_name,
    route_long_name,
    route_type,
    CASE
        when route_type = 0 then 'Light rail'
        WHEN route_type = 3 then 'Bus'
        else null
    END as route_type_desc
from source
    