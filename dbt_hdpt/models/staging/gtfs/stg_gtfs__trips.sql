with source as (
        select * from read_csv({{ source('gtfs', 'trips') }})
  )
select
    route_id,
	service_id,
	trip_id,
	trip_headsign,
	direction_id,
	CASE
		when direction_id = 0 then 'Outbound travel'
		when direction_id = 1 then 'Inbound travel'
	END as direction_id_desc,
	block_id,
	shape_id
from source