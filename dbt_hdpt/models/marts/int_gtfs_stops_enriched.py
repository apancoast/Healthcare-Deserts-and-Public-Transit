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
        'census_tract': census_tract,
        'tract_land_sq_meters': tract_land_sq_meters
    })

def model(dbt, session):
    stops_df = dbt.ref('stg_gtfs__stops').df()

    result_df = stops_df.apply(geocode_coordinates, axis=1)
    
    result_df['stop_id'] = stops_df['stop_id']
    
    # Step 4: Return the result DataFrame
    return result_df




# import duckdb

# # Connect to your DuckDB database
# con = duckdb.connect('your_database.duckdb')

# # Register your Python function
# def geocode_coordinates(stop_lat, stop_lon):
#     # Your geocoding logic here
#     # For example:
#     tract = cg.coordinates(x=stop_lon, y=stop_lat).get('Census Tracts')[0]
#     census_tract = tract.get('NAME')
#     tract_land_sq_meters = tract.get('AREALAND')
#     return census_tract, tract_land_sq_meters

# con.create_function('geocode_coordinates', geocode_coordinates)

# # Now you can use this function in your SQL query
# query = """
#     SELECT
#         stop_id,
#         stop_lat,
#         stop_lon,
#         geocode_coordinates(stop_lat, stop_lon) AS geocode_result
#     FROM
#         main_stg.stg_gtfs__stops
# """

# result_df = con.execute(query).fetchdf()
