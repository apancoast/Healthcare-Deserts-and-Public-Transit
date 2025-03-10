WITH interest_window AS (-- Week day and 7am to 7pm defines window of interest 
    SELECT
        ct.census_tract
        , t.trip_id
        , st.arrival_time
        , t.route_id
        , ct.stop_id
        , t.trip_id
    FROM stg_gtfs__stop_times st
    JOIN stg_gtfs__trips t ON st.trip_id = t.trip_id
    join int_gtfs_stops_enriched ct on st.stop_id = ct.stop_id
    WHERE 
        st.pickup_type = 0
        and t.service_id like '%Weekday%'   -- Typical PCP work days
        and date_part('hour', st.arrival_time) between 7 and 19 -- Typical PCP business
)
, counts as (
    SELECT
        census_tract
        , COUNT(DISTINCT route_id) AS number_of_routes
        , count(distinct stop_id) as number_of_stops
        , count(distinct trip_id) as number_of_trips
    from interest_window
    group by census_tract
)
, trips_per_hour AS (
    SELECT
        census_tract,
        DATE_PART('hour', arrival_time) AS hour_of_day,
        COUNT(DISTINCT trip_id) AS unique_trips_in_hour
    FROM interest_window
    GROUP BY census_tract, hour_of_day
)
SELECT
    c.census_tract
    , c.number_of_routes
    , c.number_of_stops
    , c.number_of_trips
    , MEDIAN(tph.unique_trips_in_hour) AS median_trips_per_hour
FROM counts c
JOIN trips_per_hour tph on c.census_tract = tph.census_tract
GROUP BY ALL