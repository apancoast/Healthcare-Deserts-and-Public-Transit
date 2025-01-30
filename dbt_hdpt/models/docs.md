[ '{{ doc("") }}' ]: #

# Census Bureau
{% docs model__public_insurance %}
# Public Insurance
## Overview
**Purpose**: This table selects desired variables from the source that are relevant for downstream analysis. Contains estimated totals and percentages of types of public healthcare coverage by age brackets for Census Blocks in Mecklenburg County, North Carolina.
---
### Transformation Context
**Initial Transformations**: Transformations applied to this model.
1. Parsed JSON arrays and pivoted to fit relational table format.
2. Selected 104 attributes out of 350 based on relevance to analysis. Included dropping all "annotation" columns.
3. Renamed columns.
{% enddocs %}

{% docs stg_source_census_bureau %}
## Notes and Known Issues
**General Notes**: Include any observations or decisions made during the creation of this table.  
- First pivot attempt used row_number() which is not ordered. Replaced with generate_subscript function when unnesting the array to maintain attribute order.

**Known Issues**: List any limitations or unresolved issues.  
- "Pivot macro assumes consistent JSON structure; updates may cause errors. Need to implement a better test to compare model back to source." 
{% enddocs %}

{% docs source_census_bureau__s2704 %}
## Source Dataset
- **Publisher Name**: U.S. Census Bureau, 2019-2023 American Community Survey 5-Year Estimates
- **Dataset Name**: S2704: Public Health Insurance Coverage by Type and Selected Characteristics
- **Description**: All S2704 variable for Mecklenburg County at the Census Block level.  
- **Accessed From**: `https://api.census.gov/data/2023/acs/acs5/subject?get=group(S2704)&ucgid=pseudo(0500000US37119$1400000)`  
- **Access Date**: 2024-12-14
- **Storage Location**: `s3://hdpt/raw/census_bureau/`
- **Storage File Name/Format**: `s2704.json`
{% enddocs %}

{% docs model__household_vehicles %}
# Household Vehicles
## Overview
**Purpose**: This table selects desired variables from the source that are relevant for downstream analysis. Contains estimated totals and percentages of housing tenure, household size, and count of vehicles available to household for Census Blocks in Mecklenburg County, North Carolina.
---
## Transformation Context
**Initial Transformations**: Transformations applied to raw data before staging.
1. Parsed JSON arrays and pivoted to fit relational table format.
2. Selected 42 attributes out of 1,146 based on relevance to analysis. Included dropping all "annotation" columns.
3. Renamed columns.
{% enddocs %}

{% docs source_census_bureau__dp04 %}
## Source Dataset
- **Publisher Name**: U.S. Census Bureau, 2019-2023 American Community Survey 5-Year Estimates
- **Dataset Name**: DP04: Selected Housing Characteristics
- **Description**: All DP04 variables for Mecklenburg County at the Census Block level. 
- **Accessed From**: `https://api.census.gov/data/2023/acs/acs5/profile?get=group(DP04)&ucgid=pseudo(0500000US37119$1400000)`
- **Access Date**: 2024-12-14
- **Storage Location**: `s3://hdpt/raw/census_bureau/`
- **File Name/Format**: `dp04.json`  
{% enddocs %}

# GTFS
{% docs stg_source_gtfs %}
## Source Dataset
- **Publisher Name**: The Mobility Database. https://mobilitydatabase.org/about.
- **Dataset Name**: GTFS Schedule MDB-2265. Charlotte Area Transit System (CATS).
- **Description**: "The General Transit Feed Specification (GTFS) is an Open Standard used to distribute relevant information about transit systems to riders. It allows public transit agencies to publish their transit data in a format that can be consumed by a wide variety of software applications." -https://gtfs.org/documentation/overview/.

Maintained by https://mobilitydata.org/. Column and table data catalog desciptions from https://gtfs.org/documentation/schedule/reference.
- **Accessed Via**: API
- **Accessed From**: `https://api.mobilitydatabase.org/v1/gtfs_feeds/mdb-2265`
- **Accessed Date**: 2024-12-14   
- **Storage Location**: Unzipped to `s3://hdpt/raw/gtfs/`
- **File Name(s)/Format(s)**:
    - stops.txt
    - routes.txt
    - trips.txt
    - stop_times.txt
    - calendar_dates.txt
    - shapes.txt

{% docs source_stops %}
### Stops
**Description**: Stops where vehicles pick up or drop off riders. Also defines stations and station entrances. Conditionally Required: - Optional if demand-responsive zones are defined in locations.geojson. - Required otherwise.

{% enddocs %}

{% docs source_routes %}
### Routes
**Description**: Transit routes. A route is a group of trips that are displayed to riders as a single service.

{% enddocs %}

{% docs source_trips %}
### Trips
**Description**: Trips for each route. A trip is a sequence of two or more stops that occur during a specific time period.

{% enddocs %}

{% docs source_stop_times %}
### Stop Times
**Description**: Times that a vehicle arrives at and departs from stops for each trip.

{% enddocs %}

{% docs source_calendar_dates %}
### Calendar Dates
**Description**: Exceptions for the services defined in the calendar.txt. Conditionally Required: - Required if calendar.txt is omitted. In which case calendar_dates.txt must contain all dates of service.  - Optional otherwise.

{% enddocs %}

{% docs source_shapes %}
### Shapes
**Description**: Rules for mapping vehicle travel paths, sometimes referred to as route alignments.

{% enddocs %}

# HPSA


# CMS
{% docs stg_source_cms %}
- **Publisher Name**: Centers for Medicare & Medicaid Services (CMS)
- **Dataset Name**: Doctors and Clinicians national downloadable file
- **Description**: "The Doctors and Clinicians national downloadable file is organized such that each line is unique at the clinician/enrollment record/group/address level. Clinicians with multiple Medicare enrollment records and/or single enrollments linking to multiple practice locations are listed on multiple lines." -https://data.cms.gov/provider-data/dataset/mj5m-pzi6
- **Accessed Via**: Direct download filtered for `State = NC`
- **Accessed From**: `https://data.cms.gov/provider-data/dataset/mj5m-pzi6`
- **Accessed Date**: 2025-01-28 
- **Dataset's Last Release Date (as of access date)**: 2025-01-16
- **Storage Location**: `s3://hdpt/raw/cms/`
- **File Name(s)/Format(s)**: `doc.csv`
{% enddocs %}
