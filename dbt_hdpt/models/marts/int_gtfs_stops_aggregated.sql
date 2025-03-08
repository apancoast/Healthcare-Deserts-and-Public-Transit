with stop_headways as (
    SELECT 
        st.stop_id,
        t.route_id,
        st.arrival_time
        , direction_id
        , LEAD(st.arrival_time) OVER (
            PARTITION BY st.stop_id
            ORDER BY st.arrival_time
        ) AS next_arrival_time
        , date_diff('minute', st.arrival_time::time, next_arrival_time::time) as dif
    FROM {{ ref('stg_gtfs__stop_times') }} st
    JOIN {{ ref('stg_gtfs__trips') }} t ON st.trip_id = t.trip_id
    WHERE 
        t.service_id like '%Weekday%' -- Typical PCP work days
        and date_part('hour', st.arrival_time) between 7 and 19 -- Typical PCP business hours
        and st.pickup_type = 0
    order by stop_id, st.arrival_time
)
SELECT 
    distinct
    stop_id
    , count(DISTINCT route_id) as route_counts -- Routes connected to stop
    , round(COUNT(arrival_time) / 12.0,1) AS hourly_avg_freq  -- Trips per stop in a 12-hour window
    , round(sum(dif) / 60, 1) AS avg_headway -- Average minute wait between pick-ups
FROM stop_headways
WHERE next_arrival_time IS NOT NULL
group by stop_id