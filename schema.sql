create table if not exists fips_state(
    statefp text primary key,
    state_name text,
    state_abbreviation text default ''
);

create table if not exists fips_county(
    statefp text,
    countyfp text,
    county_name text,
    primary key(statefp, countyfp),
    foreign key (statefp) references fips_state(statefp)
);

create table if not exists census_block(
    -- blockce is the natural key and is unique in the provided data
    census_block_id integer primary key, 
    statefp text,
    countyfp text,
    tractce text,
    blockid text,
    blockce text,
    partflg text,
    housing integer,
    population integer,
    foreign key (statefp,countyfp) references fips_county(statefp,countyfp)
);

create table if not exists census_shape(
    census_block_id integer primary key,
    bbox_lleft_x real,
    bbox_lleft_y real,
    bbox_uright_x real,
    bbox_uright_y real,
    area_m2 real,
    geo_json_blob text,
    foreign key (census_block_id) references census_block(census_block_id)
);

create view if not exists vw_census
as
select
    cb.census_block_id,
    cb.statefp,
    cb.countyfp,
    cb.tractce,
    cb.blockid,
    cb.blockce,
    cb.partflg,
    cb.housing,
    cb.population,
    cs.bbox_lleft_x,
    cs.bbox_lleft_y,
    cs.bbox_uright_x,
    cs.bbox_uright_y,
    cs.area_m2,
    cs.geo_json_blob
from census_block cb
inner join census_shape cs on cb.census_block_id=cs.census_block_id
;
