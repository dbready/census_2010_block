# Census 2010 Block Results

Project to prepare a SQLite database of the 2010 US Census results with population counts and GeoJSON shape files.

Script will download the Census 2010 TIGER/Line Shapefiles for [Census Blocks](https://web.archive.org/web/20220226201055/https://www.census.gov/newsroom/blogs/random-samplings/2011/07/what-are-census-blocks.html), extract/calculate the relevant data, and produce a SQLite database with the following fields:

- statefp - state [FIPS](https://web.archive.org/web/20220608002456/https://www.census.gov/library/reference/code-lists/ansi.html) code
- countyfp - county FIPS code
- tractce - tract code
- blockce - tabulation block number
- blockid - block identifier: state FIPS + county FIPS + tract code + tabulation block number
- partflg - is a partial block flag
- housing - housing unit count
- population - population count
- bbox_lleft_x - block bounding box lower left corner longitude
- bbox_lleft_y - block bounding box lower left corner latitude
- bbox_uright_x - block bounding box upper right corner longitude
- bbox_uright_y - block bounding box upper right corner latitude
- area_m2 - block area in square meters
- geo_json_blob - [GeoJSON](https://en.wikipedia.org/wiki/GeoJSON) representation of the block shape

## Usage

Assuming a Linux environment with Make, Python [poetry](https://github.com/python-poetry/poetry), and SQLite, the database can be constructed by the following:

```bash
git clone https://github.com/dbready/census_2010_block.git
cd census_2010_block
make download # ~6.5 GB
make build # ~23 GB final, requires ~70 GB during compilation
```

Output is then produced in `build/census_2010.sqlite`.

## Results

Example rows from `census_block` table:

|census_block_id|statefp|countyfp|tractce|blockid|blockce|partflg|housing|population|
|---------------|-------|--------|-------|-------|-------|-------|-------|----------|
|1|01|001|020100|1000|010010201001000|N|25|61|
|2|01|001|020100|1001|010010201001001|N|0|0|
|3|01|001|020100|1002|010010201001002|N|1|0|
|4|01|001|020100|1003|010010201001003|N|31|75|
|5|01|001|020100|1004|010010201001004|N|0|0|

Example rows from the `census_shape` table (geo_json_blob field truncated for display):

|census_block_id|bbox_lleft_x|bbox_lleft_y|bbox_uright_x|bbox_uright_y|area_m2|geo_json_blob|
|---------------|------------|------------|-------------|-------------|-------|-------------|
|1|-86.4868|32.4662|-86.4758|32.474|484007.16|{"type": "Polygon", "coordinates": [[[-86.486436, 32.4709], [-86.485722, 32.470653], [-86.485579, 32...|
|2|-86.4782|32.4668|-86.4778|32.4671|483.21|{"type": "Polygon", "coordinates": [[[-86.477916, 32.46678], [-86.478155, 32.46689], [-86.47822, 32....|
|3|-86.4877|32.4705|-86.4864|32.4713|3505.45|{"type": "Polygon", "coordinates": [[[-86.486436, 32.4709], [-86.48679899999999, 32.470509], [-86.48...|
|4|-86.4948|32.4633|-86.4787|32.4737|513281.73|{"type": "Polygon", "coordinates": [[[-86.494733, 32.467238], [-86.49474699999999, 32.467894], [-86....|
|5|-86.4799|32.4633|-86.4789|32.4639|750.43|{"type": "Polygon", "coordinates": [[[-86.479906, 32.463910999999996], [-86.478865, 32.463299], [-86...|

## License

Project is dual licensed under Apache 2 and MIT.
