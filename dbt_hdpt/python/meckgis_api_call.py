# API call to get all zips in Mecklenburg County. Will be used to filter CMS data via seed.

import requests
import os

# API URL
url = "https://meckgis.mecklenburgcountync.gov/server/rest/services/ZipCodeBoundaries/FeatureServer/0/query"

params = {
    "where": "1=1",
    "outFields": "ZIP",  # only want the ZIP field
    "returnGeometry": "false",  # don't need geometry
    "f": "json"
}

# API request
response = requests.get(url, params=params)

if response.status_code == 200:
    data = response.json()
    zip_codes = [feature["attributes"]["zip"] for feature in data.get("features", [])]

    output_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "seeds", "staging")
    os.makedirs(output_dir, exist_ok=True)

    output_path = os.path.join(output_dir, "meck_co_zip_codes.txt")

    with open(output_path, "w", encoding="utf-8") as file:
        for zip_code in zip_codes:
            file.write(str(zip_code) + "\n")

    print(f"Saved ZIP codes to {output_path}")

else:
    print(f"Error: {response.status_code}")
    
