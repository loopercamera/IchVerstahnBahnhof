-- test-data.sql
-- Enable PostGIS (once per database)
CREATE EXTENSION IF NOT EXISTS postgis;

-- Wrap everything in a transaction (optional but nice)
BEGIN;

------------------------------------------------------------
-- 1. POINTS
------------------------------------------------------------
DROP TABLE IF EXISTS demo_points;

CREATE TABLE demo_points (
    id    serial PRIMARY KEY,
    name  text,
    geom  geometry(Point, 4326)
);

INSERT INTO demo_points (name, geom) VALUES
    ('Bern, CH',
     ST_SetSRID(
         ST_GeomFromText('POINT(7.4474 46.9480)'),
         4326
     )),
    ('Zurich, CH',
     ST_SetSRID(
         ST_GeomFromText('POINT(8.5417 47.3769)'),
         4326
     )),
    ('Geneva, CH',
     ST_SetSRID(
         ST_GeomFromText('POINT(6.1432 46.2044)'),
         4326
     )),
    (
        'Zürich Bellevueplatz',
        ST_SetSRID(ST_GeomFromText('POINT(8.548407 47.365347)'), 4326)
    ),
    (
        'Zürich Platzspitz',
        ST_SetSRID(ST_GeomFromText('POINT(8.539167 47.376333)'), 4326)
    ),
    (
        'Zürich Wahlenpark',
        ST_SetSRID(ST_GeomFromText('POINT(8.559230 47.414053)'), 4326)
    ),
    (
        'Zürich Uetliberg',
        ST_SetSRID(ST_GeomFromText('POINT(8.497222 47.341667)'), 4326)
    ),
    -- Bern
    (
        'Bern Hauptbahnhof',
        ST_SetSRID(ST_GeomFromText('POINT(7.440115 46.948431)'), 4326)
    ),
    (
        'Bern Bundesplatz',
        ST_SetSRID(ST_GeomFromText('POINT(7.439803 46.941539)'), 4326)
    ),
    (
        'Bern Kornhausplatz',
        ST_SetSRID(ST_GeomFromText('POINT(7.441831 46.942441)'), 4326)
    ),
    (
        'Bern Restaurant Rosengarten',
        ST_SetSRID(ST_GeomFromText('POINT(7.4605593 46.950862)'), 4326)
    );


------------------------------------------------------------
-- 2. LINES (LINESTRING)
------------------------------------------------------------
DROP TABLE IF EXISTS demo_lines;

CREATE TABLE demo_lines (
    id    serial PRIMARY KEY,
    name  text,
    geom  geometry(LineString, 4326)
);

INSERT INTO demo_lines (name, geom) VALUES
    ('Bern to Zurich',
     ST_SetSRID(
         ST_GeomFromText('LINESTRING(7.4474 46.9480, 8.5417 47.3769)'),
         4326
     )),
    ('Zurich – Winterthur – St. Gallen (rough)',
     ST_SetSRID(
         ST_GeomFromText(
             'LINESTRING(
                 8.5417 47.3769,
                 8.7241 47.4990,
                 9.3767 47.4245
             )'
         ),
         4326
     ));

------------------------------------------------------------
-- 3. POLYGONS
------------------------------------------------------------
DROP TABLE IF EXISTS demo_polygons;

CREATE TABLE demo_polygons (
    id    serial PRIMARY KEY,
    name  text,
    geom  geometry(Polygon, 4326)
);

-- Simple rectangular-ish areas around city centers (fake extents)
INSERT INTO demo_polygons (name, geom) VALUES
    ('Bern city area (demo)',
     ST_SetSRID(
         ST_GeomFromText(
             'POLYGON((
                 7.42 46.93,
                 7.47 46.93,
                 7.47 46.96,
                 7.42 46.96,
                 7.42 46.93
             ))'
         ),
         4326
     )),
    ('Zurich city area (demo)',
     ST_SetSRID(
         ST_GeomFromText(
             'POLYGON((
                 8.50 47.35,
                 8.57 47.35,
                 8.57 47.40,
                 8.50 47.40,
                 8.50 47.35
             ))'
         ),
         4326
     ));

------------------------------------------------------------
-- 4. MULTIPOLYGON (optional example table)
------------------------------------------------------------
DROP TABLE IF EXISTS demo_multipolygons;

CREATE TABLE demo_multipolygons (
    id    serial PRIMARY KEY,
    name  text,
    geom  geometry(MultiPolygon, 4326)
);

INSERT INTO demo_multipolygons (name, geom) VALUES
    ('Two demo areas near Zurich & Bern',
     ST_SetSRID(
         ST_GeomFromText(
             'MULTIPOLYGON(
                 (
                     (8.50 47.35, 8.57 47.35, 8.57 47.40, 8.50 47.40, 8.50 47.35)
                 ),
                 (
                     (7.42 46.93, 7.47 46.93, 7.47 46.96, 7.42 46.96, 7.42 46.93)
                 )
             )'
         ),
         4326
     ));

COMMIT;

------------------------------------------------------------
-- 5. QUICK CHECK QUERIES (optional, comment out if you don’t want them)
------------------------------------------------------------
-- SELECT id, name, ST_AsText(geom) AS wkt FROM demo_points;
-- SELECT id, name, ST_AsText(geom) AS wkt FROM demo_lines;
-- SELECT id, name, ST_AsText(geom) AS wkt FROM demo_polygons;
-- SELECT id, name, ST_AsText(geom) AS wkt FROM demo_multipolygons;
