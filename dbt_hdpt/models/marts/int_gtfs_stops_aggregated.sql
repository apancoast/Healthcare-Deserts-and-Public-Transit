with interest_window as ( -- Weekday and 7am to 7pm defines "window" of interest, referenced by later columns
    SELECT 
        st.stop_id
        , st.arrival_time
    FROM stg_gtfs__stop_times st
    JOIN stg_gtfs__trips t ON st.trip_id = t.trip_id
    WHERE 
        st.pickup_type = 0
        and t.service_id like '%Weekday%' -- Typical PCP work days
        and date_part('hour', st.arrival_time) between 7 and 19 -- Typical PCP business hours 
)
, headway_calculations as (
    SELECT
        stop_id
        , COUNT(arrival_time) AS total_pickups_in_window -- Number of pickups throughout the day
    FROM interest_window
    group by stop_id
)
, routes as (
    select
        st.stop_id
        , count(distinct t.route_id) as route_counts -- Number of routes that use stop
    FROM stg_gtfs__stop_times st
    JOIN stg_gtfs__trips t ON st.trip_id = t.trip_id
    GROUP by st.stop_id
)
SELECT 
    calcs.stop_id
    , route_counts 
    , total_pickups_in_window
FROM headway_calculations calcs
JOIN routes rts on rts.stop_id = calcs.stop_id
;