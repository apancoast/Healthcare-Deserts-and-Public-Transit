-- staging
use hdpt_dev.stage;

-- hpsa shapefiles
LOAD spatial;

create table if not exists stage.hpsa_shape as SELECT * FROM  ST_Read('/vsizip/C:\Users\panco\Downloads\HPSA_CMPPC_SHP.zip\HPSA_CMPPC_SHP_DET_CUR_VX.shp')

select * from hpsa_shape limit 2;


--jsons from census burea

--gtfs .txts
