--Parsing JSONs


--Preview data
SELECT *
; describe FROM read_json_objects('s3://hdpt/raw/jsons/s2704.json'); --read as a json

SELECT * FROM read_json('s3://hdpt/raw/jsons/s2704.json') --this function reads as a table
;

SELECT * FROM read_json_objects('s3://hdpt/raw/jsons/s2704.json') limit 1;

-- trying this
with raw_data as (
SELECT * FROM read_json('s3://hdpt/raw/jsons/s2704.json')
)
, headers AS (-- Step 3: Extract headers
    SELECT * AS header_array
    FROM raw_data
    LIMIT 1
)
--, rows AS ( --Step 4: Extract rows (all but the first row)
--    SELECT *
--    FROM raw_data
--    OFFSET 1
--)
--, final_data AS ( -- Step 5: Dynamically construct a table using headers
--    SELECT 
--        row_array[1] AS {{ (SELECT header_array[1] FROM headers) }},
--        row_array[2] AS {{ (SELECT header_array[2] FROM headers) }}
--        -- Add more dynamically if needed
--    FROM rows
--)
--what about unnesting everything
SELECT unnest(header_array) AS x, generate_subscripts(header_array, 1) as y from headers;

SELECT unnest(header_array) FROM headers; -- Can I return this array flattened, set it as a variable using or at least in dbt, then use it for a "CREATE TABLE foo USING"

SELECT *
FROM final_data;

--from dbt rec
WITH raw_data AS ( -- Step 1: Read the JSON file
    SELECT *
    FROM read_json('s3://hdpt/raw/jsons/s2704.json')
)
, unnested_data AS ( -- Step 2: Unnest each row (array) into individual elements
    SELECT 
        row_number() OVER () AS record_id, 
        unnest(json) AS element
    FROM raw_data
	--QUALIFY row_id = 2;
)
, header as (
	SELECT *
	FROM unnested_data
	WHERE record_id = 1
)
PIVOT header
ON row_id
USING ⟨values⟩
GROUP BY record
;
    
    
--), pivoted_data AS ( -- Step 3: Pivot unnested elements into columns
--    SELECT 
--        row_id,
--        351 -- Adjust max_columns based on expected data size
--    FROM (
--        SELECT 
--            row_id, 
--            list_agg(element) AS elements
--        FROM unnested_data
--        GROUP BY row_id