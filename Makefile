.PHONY : download
download : 
	mkdir --parents data/raw/
	wget \
		--accept=.zip \
		--cut-dirs=2 \
		--directory-prefix=data/raw/ \
		--execute robots=off \
		--no-clobber \
		--no-host-directories \
		--no-parent \
		--random-wait \
		--recursive \
		--relative \
		--show-progress \
		https://www2.census.gov/geo/tiger/TIGER2010BLKPOPHU/

.PHONY : build
build : build/census_2010.sqlite

build/census_2010.sqlite : 
	mkdir --parents build/
	poetry install
	sqlite3 build/census_2010.sqlite.temp < schema.sql
	sqlite3 -csv build/census_2010.sqlite.temp ".import --skip 1 data/fips_county.csv fips_county"
	sqlite3 -csv build/census_2010.sqlite.temp ".import --skip 1 data/fips_state.csv fips_state"
	poetry run python extract_shapefiles.py data/raw/TIGER2010BLKPOPHU build/census_2010.sqlite.temp
	sqlite3 build/census_2010.sqlite.temp < munge.sql
	mv build/census_2010.sqlite.temp build/census_2010.sqlite
