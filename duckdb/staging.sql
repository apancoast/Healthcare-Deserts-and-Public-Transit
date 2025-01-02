-- creating staging layer
CREATE SCHEMA IF NOT EXISTS stage;

-- staging
use hdpt_dev.stage;

-- hpsa shapefiles
LOAD spatial;

create table if not exists stage.hpsa_shape as SELECT * FROM  ST_Read('/vsizip/C:\Users\panco\Downloads\HPSA_CMPPC_SHP.zip\HPSA_CMPPC_SHP_DET_CUR_VX.shp') -- can I load this FROM S3 just NOT IN the zip?

select * from hpsa_shape limit 2;

-- query Census Bureau JSONs from S3 without download: https://duckdb.org/docs/guides/network_cloud_storage/duckdb_over_https_or_s3
-- using temporary attachments: https://duckdb.org/docs/sql/statements/attach.html
install httpfs;
LOAD httpfs;

SELECT *
FROM read_json('s3://hdpt/raw/jsons/s2704.json')
LIMIT 2;
-- gtfs .txts

CALL load_aws_credentials('default');