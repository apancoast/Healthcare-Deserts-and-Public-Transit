--Parsing JSONs
--attach for session
ATTACH 's3://hdpt/raw/jsons/s2704.json' as json_file;

--Preview data
with t1 as (SELECT *
FROM read_json_objects('s3://hdpt/raw/jsons/s2704.json')
LIMIT 2)
select  from t1 limit 1
;

--describe it
describe from read_json_objects('s3://hdpt/raw/jsons/s2704.json') limit 1;

SELECT $[0] as headers
FROM read_json_objects('s3://hdpt/raw/jsons/s2704.json')
LIMIT 1;

--ChatGPT suggestion
WITH parsed_json AS (
    SELECT
        jsno(json) AS json_array
    FROM read_json('s3://hdpt/raw/jsons/s2704.json')
),

split_headers_and_rows AS (
    SELECT
        json_array[0] AS headers, -- Extract headers (first element)
        json_array[1:] AS rows   -- Extract rows (remaining elements)
    FROM parsed_json
),

unnest_rows AS (
    SELECT
        idx AS row_index,
        rows AS row_data
    FROM split_headers_and_rows, UNNEST(rows) WITH ORDINALITY AS t(rows, idx)
),

map_headers_to_columns AS (
    SELECT
        row_index,
        headers[column_index - 1] AS column_name,
        row_data[column_index - 1] AS column_value
    FROM unnest_rows, UNNEST(headers) WITH ORDINALITY AS t(headers, column_index)
),

pivoted_table AS (
    SELECT
        row_index,
        column_name,
        column_value
    FROM map_headers_to_columns
)
SELECT
    *
FROM pivoted_table
PIVOT (
    MAX(column_value) -- Aggregate function for pivoting (values are unique per row/column combo)
    FOR column_name IN (SELECT DISTINCT headers FROM split_headers_and_rows)
);
