import requests
import time
from pathlib import Path
from tqdm import tqdm

OVERPASS_URL = "https://overpass-api.de/api/interpreter"
OUTPUT_DIR = Path("stations_world")
OUTPUT_DIR.mkdir(exist_ok=True)

# Grid configuration
ROWS = 10
COLS = 20

def make_query(s, w, n, e):
    return f"""
    [out:json][timeout:180];

    (
      node["railway"="station"]({s},{w},{n},{e});
      way["railway"="station"]({s},{w},{n},{e});
      relation["railway"="station"]({s},{w},{n},{e});

      node["amenity"="bus_station"]({s},{w},{n},{e});
      way["amenity"="bus_station"]({s},{w},{n},{e});
    );

    out body;
    >;
    out skel qt;
    """

def download_tile(tile_id, south, west, north, east):
    print(f"Tile {tile_id}: {south},{west},{north},{east}")

    query = make_query(south, west, north, east)
    resp = requests.post(OVERPASS_URL, data=query)

    if resp.status_code == 200:
        out_file = OUTPUT_DIR / f"stations_tile_{tile_id}.json"
        with open(out_file, "w", encoding="utf-8") as f:
            f.write(resp.text)
        print(f"Saved {out_file}")
    else:
        print(f"Error tile {tile_id}: HTTP {resp.status_code}")

def main():
    lat_step = 180 / ROWS
    lon_step = 360 / COLS

    total_tiles = ROWS * COLS
    tile_id = 0

    for _ in tqdm(range(total_tiles), desc="Downloading world tiles"):
        i = tile_id // COLS
        j = tile_id % COLS

        south = -90 + i * lat_step
        north = -90 + (i + 1) * lat_step
        west  = -180 + j * lon_step
        east  = -180 + (j + 1) * lon_step

        download_tile(tile_id, south, west, north, east)
        tile_id += 1

        time.sleep(5)

if __name__ == "__main__":
    main()
