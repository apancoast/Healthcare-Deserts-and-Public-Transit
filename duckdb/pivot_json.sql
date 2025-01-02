-- Step 1: Read the JSON file
WITH raw_data AS (
    SELECT *
    FROM read_json('s3://hdpt/raw/jsons/s2704.json')
)
, header AS ( -- Step 2: Unnest each row (array) into individual elements
    SELECT 
        row_number() OVER () AS record_id, 
        unnest(json) AS element
    FROM raw_data
    QUALIFY record_id = 1
) -- Step 3: Extract data rows (remaining rows)
, data_rows AS (
    SELECT 
        row_number() OVER () AS record_id, 
        unnest(json) AS element
    FROM raw_data
    QUALIFY record_id > 1
) -- Step 4: Assign headers dynamically to data
SELECT *
FROM data_rows
   PIVOT (
        MIN(value) FOR row_id IN (
            SELECT string_agg(header_name, ', ') FROM header
        )
    ;
