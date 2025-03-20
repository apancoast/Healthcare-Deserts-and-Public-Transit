import censusgeocode as cg
import pandas as pd

# Function to geocode a single row (coordinates)
def geocode_coordinates(row):
    stop_lat = row['stop_lat']
    stop_lon = row['stop_lon']
    
    # Get the census tract data
    tract = cg.coordinates(x=stop_lon, y=stop_lat).get('Census Tracts')[0]
    
    # Extract the relevant fields
    census_tract = tract.get('NAME')
    tract_land_sq_meters = tract.get('AREALAND')
    
    return pd.Series({
        'census_tract': str(census_tract),
        'tract_land_sq_meters': int(tract_land_sq_meters)
    })

def model(dbt, session):
    stops_df = dbt.ref('stg_gtfs__stops').df()

    result_df = stops_df.apply(geocode_coordinates, axis=1)
    
    result_df['stop_id'] = stops_df['stop_id'].astype(str)
    
    return result_df
