with insurance as (
    select
        split_part(geo_name, ';', 1) as census_tract
        , tot_pop
        , pct_pub_cov_medicare_alone_or_comb
        , pct_pub_cov_medicaid_alone_or_comb
    FROM {{ ref('stg_census_bureau__public_insurance') }}
)
, households as (
    select
    split_part(geo_name, ';', 1) as census_tract
        , housing_tenure
        , veh_avail_veh_none
        , veh_avail_veh_1
        , veh_avail_veh_2
        , veh_avail_veh_3plus
    from {{ ref('stg_census_bureau__household_vehicles') }}
)
, transit as (
    select
        agg.census_tract 
        , agg.number_of_stops
        , agg.number_of_trips
        , agg.number_of_routes
        , enr.tract_land_sq_meters
        , round((agg.number_of_stops / NULLIF(enr.tract_land_sq_meters, 0)) * 1000000, 2) AS stops_per_km2
    from {{ ref('int_census_tract_gtfs_aggregated') }} as agg
    left join {{ ref('int_gtfs_stops_enriched') }} as enr using (census_tract)
)
select distinct
    i.census_tract
    , i.tot_pop as total_population
    , h.housing_tenure as total_households
    , t.stops_per_km2
    , t.tract_land_sq_meters
    , h.veh_avail_veh_none as households_with_0_vehicles
    , h.veh_avail_veh_1 as households_with_1_vehicle
    , h.veh_avail_veh_2 as households_with_2_vehicles
    , h.veh_avail_veh_3plus as households_with_3plus_vehicles
    , t.number_of_stops
    , t.number_of_trips
    , t.number_of_routes
    , i.pct_pub_cov_medicare_alone_or_comb
    , i.pct_pub_cov_medicaid_alone_or_comb
FROM insurance as i
LEFT JOIN households as h using (census_tract)
LEFT JOIN transit as t using (census_tract)

