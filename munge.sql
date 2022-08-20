insert into census_block(statefp,countyfp,tractce,blockid,blockce,partflg,housing,population)
select
    statefp,
    countyfp,
    tractce,
    blockid,
    blockce,
    partflg,
    housing,
    population
from load_census
order by blockce;

insert into census_shape(census_block_id,bbox_lleft_x,bbox_lleft_y,bbox_uright_x,bbox_uright_y,area_m2,geo_json_blob)
select
    census_block_id,
    bbox_lleft_x,
    bbox_lleft_y,
    bbox_uright_x,
    bbox_uright_y,
    area_m2,
    geo_json_blob
from load_census
inner join census_block on load_census.blockce=census_block.blockce
order by census_block_id;

drop table load_census;

vacuum;
