with transit_score as (
    select
        ct.census_tract
        , round(round((0.3 * ct.stops_per_km2),1) + round((0.35 * agg.median_trips_per_hour),1) + round((0.35 * ct.number_of_routes),1),1) as public_transport_score
    from census_tracts as ct
    left join {{ ref('int_census_tract_gtfs_aggregated') }} as agg using (census_tract)
)
, transit_threshold as (
    select
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY public_transport_score) as public_transit_score_25th_percentile
    from transit_score
)
, tracts as (
    select
        ct.census_tract
        , case
            when hs.census_tract is not null then 'TRUE'
            else 'FALSE'
        end as healthcare_shortage_flag
        , case
            when (pct_pub_cov_medicare_alone_or_comb + pct_pub_cov_medicaid_alone_or_comb) > 35.0 then 'TRUE'
            else 'FALSE'
        end as public_insurance_dependency_flag
    from {{ ref('census_tracts') }} ct
    left join {{ ref('healthcare_shortage') }} hs on ct.census_tract = hs.census_tract
)
, vehicles as (
    select
        split_part(geo_name, ';', 1) as census_tract
        , (pct_veh_avail_veh_none) + (.5 * pct_veh_avail_veh_1) as households_low_vehicle_availability
        , case
            when (pct_veh_avail_veh_none) + (.5 * pct_veh_avail_veh_1) > 65 then 1
            when (pct_veh_avail_veh_none) + (.5 * pct_veh_avail_veh_1) between 30 and 65 then 2
            else 3
        end as vehicle_availability_indicator
        , case
            when (pct_veh_avail_veh_none) + (.5 * pct_veh_avail_veh_1) > 65 then 'Low'
            when (pct_veh_avail_veh_none) + (.5 * pct_veh_avail_veh_1) between 30 and 65 then 'Medium'
            else 'High'
        end as vehicle_availability_description
    from {{ ref('stg_census_bureau__household_vehicles') }}
    where pct_veh_avail_veh_none is not null
    and pct_veh_avail_veh_1 is not null
)
select 
    ts.census_tract
    , ts.public_transport_score
    , case
        when ts.public_transport_score < tt.public_transit_score_25th_percentile then 'TRUE'
        else 'FALSE'
    end as public_transit_barrier_flag
    , v.households_low_vehicle_availability
    , v.vehicle_availability_indicator
    , v.vehicle_availability_description
    , CASE
        WHEN public_transit_barrier_flag = 'TRUE' 
            AND v.vehicle_availability_indicator IN ('1', '2') 
        THEN 'TRUE'
        ELSE 'FALSE'
    END AS combined_transportation_barrier_flag
    , ct.healthcare_shortage_flag
    , ct.public_insurance_dependency_flag
from transit_score as ts
cross join transit_threshold as tt
left join vehicles as v using (census_tract)
left join tracts as ct using (census_tract)
where healthcare_shortage_flag = 'TRUE'
order by combined_transportation_barrier_flag