"""Add a location to GNOME Weather and the GNOME Shell weather applet."""

from __future__ import annotations

import argparse
import json
import sys
import urllib.error
import urllib.parse
import urllib.request

import gi

gi.require_version("GWeather", "4.0")
gi.require_version("Gio", "2.0")
from gi.repository import Gio, GLib, GWeather  # noqa: E402

NOMINATIM_URL = "https://nominatim.openstreetmap.org/search"
USER_AGENT = "gnome-weather-set/1.0 (+https://github.com/surfaceflinger/notflake)"
SCHEMAS = ("org.gnome.Weather", "org.gnome.shell.weather")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("query", nargs="*", help="location to search for")
    parser.add_argument(
        "--replace",
        action="store_true",
        help="replace all existing locations",
    )
    parser.add_argument(
        "-y",
        "--yes",
        action="store_true",
        help="do not ask for confirmation",
    )
    return parser.parse_args()


def search_location(query: str) -> dict:
    params = urllib.parse.urlencode({"q": query, "format": "jsonv2", "limit": 1})
    request = urllib.request.Request(
        f"{NOMINATIM_URL}?{params}",
        headers={"User-Agent": USER_AGENT},
    )
    try:
        with urllib.request.urlopen(request, timeout=20) as response:
            results = json.load(response)
    except (
        urllib.error.URLError,
        TimeoutError,
        json.JSONDecodeError,
    ) as error:
        raise SystemExit(f"Location lookup failed: {error}") from error

    if not isinstance(results, list) or not results:
        raise SystemExit(
            f"No locations found for {query!r}; try a less specific query."
        )
    return results[0]


def location_name(result: dict) -> str:
    return result.get("name") or result["display_name"].split(",", 1)[0]


def make_location(result: dict) -> GWeather.Location:
    try:
        latitude = float(result["lat"])
        longitude = float(result["lon"])
    except (KeyError, ValueError) as error:
        raise SystemExit(
            f"Nominatim returned an invalid location: {result!r}"
        ) from error

    if not -90 <= latitude <= 90 or not -180 <= longitude <= 180:
        raise SystemExit(f"Coordinates out of range: {latitude}, {longitude}")

    # libgweather takes degrees here and serializes them as radians.
    return GWeather.Location.new_detached(
        location_name(result), None, latitude, longitude
    )


def add_location(
    settings: Gio.Settings,
    location: GWeather.Location,
    replace: bool,
) -> bool:
    serialized = location.serialize()

    if replace:
        values = []
    else:
        current = settings.get_value("locations")
        values = [current.get_child_value(i) for i in range(current.n_children())]
        if any(value.equal(GLib.Variant.new_variant(serialized)) for value in values):
            return False

    values.append(GLib.Variant.new_variant(serialized))
    settings.set_value(
        "locations", GLib.Variant.new_array(GLib.VariantType("v"), values)
    )
    settings.sync()
    return True


def confirm(prompt: str) -> bool:
    try:
        answer = input(f"{prompt} [y/N] ").strip().lower()
    except EOFError:
        return False
    return answer in {"y", "yes"}


def main() -> int:
    args = parse_args()
    query = " ".join(args.query).strip()

    if not query:
        try:
            query = input("Location to add to GNOME Weather: ").strip()
        except EOFError:
            print("No location provided.", file=sys.stderr)
            return 1

    if not query:
        print("No location provided.", file=sys.stderr)
        return 1

    result = search_location(query)
    display_name = result.get("display_name", location_name(result))
    location = make_location(result)

    replace = args.replace
    if not args.yes:
        if not confirm(f"Add {display_name!r}?"):
            print("Not adding location.")
            return 1
        if not replace:
            replace = confirm("Replace existing locations?")

    changed_any = False
    for schema in SCHEMAS:
        try:
            settings = Gio.Settings.new(schema)
            changed = add_location(settings, location, replace)
        except GLib.Error as error:
            raise SystemExit(f"Failed to update {schema}: {error.message}") from error

        changed_any = changed_any or changed
        if not changed:
            print(f"{display_name} is already present in {schema}.")

    if changed_any:
        print(f"Added {display_name}.")
    else:
        print("No changes.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
