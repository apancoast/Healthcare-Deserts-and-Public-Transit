with source as (
        select * from read_csv({{ source('gtfs', 'stops') }})
  )
select
	stop_id,
	stop_code,
	stop_name,
	stop_lat,
	stop_lon,
	location_type,
	CASE
		when location_type = 0 or location_type is null then 'stop'
		when location_type = 1 then 'station'
		else null
	END as location_type_desc,
	parent_station    
from source

    