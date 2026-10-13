#!/usr/bin/env bash
set -euo pipefail

# confirm user input
confirm() {
  local prompt="$1"
  local answer
  read -rp "$prompt [y/n]: " answer
  [[ $answer == "y" ]]
}

deg_to_rad() {
  local deg="$1"
  echo "$deg * 4 * a(1) / 180" | bc -l
}

fetch_location() {
  query="$*"
  if [[ -z $query ]]; then
    read -rp "Type the name of the location you want to add to GNOME Weather: " query
  fi
  query=$(jq -rn --arg q "$query" '$q|@uri')
  local result
  result=$(curl "https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1" -s)
  if [[ -z $result || $result == '[]' ]]; then
    echo "No locations found, consider being less specific"
    exit 1
  fi
  echo "$result"
}

convert_to_gnome_format() {
  local request="$1"
  local name
  local lat
  local lon

  name=$(echo "$request" | jq -r '.[0].name')
  lat=$(deg_to_rad "$(echo "$request" | jq -r '.[0].lat')")
  lon=$(deg_to_rad "$(echo "$request" | jq -r '.[0].lon')")
  echo "<(uint32 2, <('$name', '', false, [($lat, $lon)], @a(dd) [])>)>"
}

add_location() {
  local location="$1"
  local replace="${2:-false}"
  local schemas=("org/gnome/shell/weather" "org/gnome/Weather")
  for schema in "${schemas[@]}"; do
    local locations
    locations=$(dconf read "/$schema/locations")
    if [[ $locations == "@av []" || $replace == true ]]; then
      dconf write "/$schema/locations" "[$location]"
    else
      dconf write "/$schema/locations" "${locations/%]/, $location]}"
    fi
  done
}

request=$(fetch_location "$@")
location=$(convert_to_gnome_format "$request")

if ! confirm "If this is not the location you wanted, consider adding search terms. Are you sure you want to add $location?"; then
  echo "Not adding location"
  exit 1
else
  echo "Adding location"
fi

replace=$(confirm "Would you like to replace existing locations? This will remove previous locations" && echo true || echo false)
add_location "$location" "$replace"
