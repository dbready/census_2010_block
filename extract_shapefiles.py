import argparse
import json
import os
import sqlite3

import area
import shapefile
import tqdm


def gen_rows(filename):
    with shapefile.Reader(filename) as sf:
        for shapeRec in sf:
            shape = shapeRec.shape
            bbox = shape.bbox
            rec = shapeRec.record
            geojson = shape.__geo_interface__
            meters_sq = area.area(geojson)
            row = [*list(rec), *bbox, meters_sq, json.dumps(geojson)]
            yield row


def add_loading_table(con):
    con.execute(
        """
    create table if not exists load_census(
        statefp text,
        countyfp text,
        tractce text,
        blockid text,
        blockce text,
        partflg text,
        housing integer,
        population integer,
        bbox_lleft_x real,
        bbox_lleft_y real,
        bbox_uright_x real,
        bbox_uright_y real,
        area_m2 real,
        geo_json_blob text
    );
    """
    )


def main(dir_data, fname_db):
    con = sqlite3.connect(fname_db)
    add_loading_table(con)

    filenames = []
    for fname in sorted(os.listdir(dir_data)):
        filename = os.path.join(dir_data, fname)
        filenames.append(filename)

    for filename in tqdm.tqdm(filenames):
        rows = gen_rows(filename)
        con.executemany(
            """
            insert into load_census(
                statefp,
                countyfp,
                tractce,
                blockid,
                blockce,
                partflg,
                housing,
                population,
                bbox_lleft_x,
                bbox_lleft_y,
                bbox_uright_x,
                bbox_uright_y,
                area_m2,
                geo_json_blob
            ) 
            values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
            rows,
        )
    con.commit()
    con.close()


def get_args():
    parser = argparse.ArgumentParser()
    parser.add_argument("dir_data", help="directory containing Census shape files")
    parser.add_argument("fname", help="SQLite destination database")
    args = parser.parse_args()
    return args


if __name__ == "__main__":
    args = get_args()

    main(args.dir_data, args.fname)
