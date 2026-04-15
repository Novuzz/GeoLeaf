import json

# Load the expanded coordinates
with open('coordenadasLocaisExpandidas.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

print(f"Converting {len(data['builder'])} locations to GeoJSON format...")

# Create GeoJSON FeatureCollection
features = []

for location in data['builder']:
    location_id = location['id']
    location_name = location['name']
    coordinates = location['expanded_coordinates']
    
    # Convert from [lat, lon] to [lon, lat] and close the polygon
    geom_coords = []
    for coord in coordinates:
        geom_coords.append([coord[1], coord[0]])  # Swap lat/lon to lon/lat
    
    # Close the polygon by adding the first coordinate at the end
    if len(geom_coords) > 0 and geom_coords[0] != geom_coords[-1]:
        geom_coords.append(geom_coords[0])
    
    # Create feature
    feature = {
        "type": "Feature",
        "properties": {
            "id": location_id,
            "name": location_name
        },
        "geometry": {
            "type": "Polygon",
            "coordinates": [geom_coords]
        }
    }
    
    features.append(feature)

# Create FeatureCollection
geojson_data = {
    "type": "FeatureCollection",
    "features": features
}

# Save to GeoJSON file
output_file = 'coordenadasLocaisExpandidas.geojson'
with open(output_file, 'w', encoding='utf-8') as f:
    json.dump(geojson_data, f, indent=2, ensure_ascii=False)

print(f"✓ Created {output_file} with {len(features)} features")
