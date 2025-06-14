import os
import pandas as pd
import requests

def model(dbt, session):
    # Get API key from environment variable
    CENSUS_API_KEY = os.environ["CENSUS_API_KEY"]

    params = {
        "get": "group(GEOINFO)",
        "ucgid": "pseudo(0500000US37119$1400000)",
        "key": CENSUS_API_KEY
    }

    url = "https://api.census.gov/data/2023/geoinfo"

    # Make the request
    response = requests.get(url, params=params)
    response.raise_for_status()

    # Parse the JSON response
    data = response.json()
    data_df = pd.DataFrame(data[1:], columns=data[0])

    # Select and clean relevant columns
    selected = data_df[["NAME", "AREALAND"]].copy()
    selected["NAME"] = selected["NAME"].str.split(";").str[0]
    selected = selected.rename(columns={
        "NAME": "census_tract",
        "AREALAND": "tract_land_sq_meters"
    })

    return selected