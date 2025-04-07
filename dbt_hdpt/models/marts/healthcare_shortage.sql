select 
    split_part(hpsa_comp_name, ',', 1) as census_tract
    , hpsa_source_id as source_id
    , hpsa_score as score
    , hpsa_shortage as shortage
    , hpsa_formal_ratio as population_to_provider_ratio
    , hpsa_tot_fte_clinicians as fte_clinicians
    , hpsa_pct_of_pop_below_pl as pct_of_population_below_poverty_line
    , hpsa_des_date as designation_date
    , hpsa_des_pop as designation_pop
    , hpsa_est_underserved_pop as est_underserved_pop
    , hpsa_est_served_pop as est_served_pop
    , hpsa_provider_ratio_goal as provider_ratio_goal
    , shape_object_id as shape_object_id
    , geometry as geometry
from {{ ref('stg_hpsa__components_shapefile') }}