with source as (
        select * from read_csv({{ source('gtfs', 'stop_times') }},types = {'arrival_time': 'timetz', 'departure_time': 'timetz'})
  )
select
    cast(trip_id as varchar) as trip_id,
	arrival_time,
	departure_time,
	stop_id,
	stop_sequence,
	pickup_type,
	CASE
		when pickup_type = 0 or pickup_type is null then 'Regularly scheduled pickup'
		when pickup_type = 1 then 'No pickup available'
		else null
	END as pickup_type_desc,
	drop_off_type,
	CASE
		when drop_off_type = 0 or drop_off_type is null then 'Regularly scheduled drop off'
	else null
	END as drop_off_type_desc,
	timepoint,
	CASE
		WHEN timepoint = 0 then 'Times are considered approximate'
		when timepoint = 1 or timepoint is null then 'Times are considered exact'
	else null
	END as timepoint_desc
from source