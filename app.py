"""
Railway Trip Management - Flask Web Application
UMBB - FS CS Department - L3 DSS - 2025/2026

Uses:
  - xml.dom.minidom  → DOM  : display complete trip info
  - xml.etree.ElementTree → ElementTree : statistics (cheapest/most expensive, counts)
"""

from flask import Flask, render_template, request, jsonify
import xml.dom.minidom as minidom
import xml.etree.ElementTree as ET

app = Flask(__name__)
XML_FILE = "transport.xml"


# ─────────────────────────────────────────────
#  DOM HELPERS  (complete trip info)
# ─────────────────────────────────────────────

def get_all_trips_dom():
    """Return all trips as a list of dicts using DOM."""
    doc = minidom.parse(XML_FILE)
    trips = []
    for line in doc.getElementsByTagName("line"):
        line_id  = line.getAttribute("id")
        line_dep = line.getAttribute("departure")
        line_arr = line.getAttribute("arrival")
        for trip in line.getElementsByTagName("trip"):
            trip_id  = trip.getAttribute("id")
            dep_city = trip.getAttribute("departure")
            arr_city = trip.getAttribute("arrival")

            sched    = trip.getElementsByTagName("schedule")[0]
            dep_time = sched.getElementsByTagName("departure_time")[0].firstChild.nodeValue
            arr_time = sched.getElementsByTagName("arrival_time")[0].firstChild.nodeValue

            train_type = trip.getElementsByTagName("train")[0].getAttribute("type")

            classes = []
            for cls in trip.getElementsByTagName("class"):
                classes.append({
                    "name":  cls.getAttribute("name"),
                    "price": int(cls.getAttribute("price"))
                })

            trips.append({
                "line_id":     line_id,
                "line_dep":    line_dep,
                "line_arr":    line_arr,
                "trip_id":     trip_id,
                "departure":   dep_city,
                "arrival":     arr_city,
                "dep_time":    dep_time,
                "arr_time":    arr_time,
                "train_type":  train_type,
                "classes":     classes,
                "min_price":   min(c["price"] for c in classes),
                "max_price":   max(c["price"] for c in classes),
            })
    return trips


def get_trip_by_id_dom(trip_id):
    """Return a single trip dict by trip ID using DOM."""
    for t in get_all_trips_dom():
        if t["trip_id"].upper() == trip_id.upper():
            return t
    return None


# ─────────────────────────────────────────────
#  ELEMENTTREE HELPERS  (statistics)
# ─────────────────────────────────────────────

def compute_statistics_et():
    """
    Using ElementTree:
    1. Cheapest & most expensive trip per line
    2. Number of trips per train type
    """
    tree = ET.parse(XML_FILE)
    root = tree.getroot()

    line_stats   = []
    type_counter = {}

    for line in root.findall("line"):
        line_id  = line.get("id")
        dep      = line.get("departure")
        arr      = line.get("arrival")

        trips_info = []
        for trip in line.findall("trip"):
            trip_id    = trip.get("id")
            train_type = trip.find("train").get("type")
            dep_time   = trip.find("schedule/departure_time").text
            arr_time   = trip.find("schedule/arrival_time").text

            prices = [int(c.get("price")) for c in trip.findall("classes/class")]
            min_p  = min(prices)
            max_p  = max(prices)

            trips_info.append({
                "trip_id":    trip_id,
                "train_type": train_type,
                "dep_time":   dep_time,
                "arr_time":   arr_time,
                "min_price":  min_p,
                "max_price":  max_p,
            })

            # count per train type
            type_counter[train_type] = type_counter.get(train_type, 0) + 1

        if trips_info:
            cheapest   = min(trips_info, key=lambda x: x["min_price"])
            expensive  = max(trips_info, key=lambda x: x["max_price"])
            line_stats.append({
                "line_id":    line_id,
                "departure":  dep,
                "arrival":    arr,
                "nb_trips":   len(trips_info),
                "cheapest":   cheapest,
                "expensive":  expensive,
            })

    return line_stats, type_counter


# ─────────────────────────────────────────────
#  ROUTES
# ─────────────────────────────────────────────

@app.route("/")
def index():
    all_trips = get_all_trips_dom()
    departures = sorted(set(t["departure"] for t in all_trips))
    arrivals   = sorted(set(t["arrival"]   for t in all_trips))
    types      = sorted(set(t["train_type"] for t in all_trips))
    return render_template("index.html",
                           trips=all_trips,
                           departures=departures,
                           arrivals=arrivals,
                           types=types)


@app.route("/search")
def search():
    """Search / filter trips."""
    all_trips  = get_all_trips_dom()
    trip_code  = request.args.get("trip_code", "").strip()
    dep_filter = request.args.get("departure", "").strip()
    arr_filter = request.args.get("arrival", "").strip()
    type_filter= request.args.get("train_type", "").strip()
    max_price  = request.args.get("max_price", "").strip()

    results = all_trips

    # 1. Search by trip code
    if trip_code:
        results = [t for t in results if trip_code.upper() in t["trip_id"].upper()]

    # 2. Filter by departure
    if dep_filter:
        results = [t for t in results if t["departure"].lower() == dep_filter.lower()]

    # 3. Filter by arrival
    if arr_filter:
        results = [t for t in results if t["arrival"].lower() == arr_filter.lower()]

    # 4. Filter by train type
    if type_filter:
        results = [t for t in results if t["train_type"].lower() == type_filter.lower()]

    # 5. Filter by max price  (keep trips where min_price <= max_price)
    if max_price:
        try:
            mp = int(max_price)
            results = [t for t in results if t["min_price"] <= mp]
        except ValueError:
            pass

    departures = sorted(set(t["departure"] for t in all_trips))
    arrivals   = sorted(set(t["arrival"]   for t in all_trips))
    types      = sorted(set(t["train_type"] for t in all_trips))

    return render_template("index.html",
                           trips=results,
                           departures=departures,
                           arrivals=arrivals,
                           types=types,
                           filters={
                               "trip_code":  trip_code,
                               "departure":  dep_filter,
                               "arrival":    arr_filter,
                               "train_type": type_filter,
                               "max_price":  max_price,
                           })


@app.route("/trip/<trip_id>")
def trip_detail(trip_id):
    """Display complete info for one trip (DOM)."""
    trip = get_trip_by_id_dom(trip_id)
    if not trip:
        return render_template("error.html", message=f"Trip '{trip_id}' not found."), 404
    return render_template("trip_detail.html", trip=trip)


@app.route("/statistics")
def statistics():
    """Statistics page (ElementTree)."""
    line_stats, type_counter = compute_statistics_et()
    return render_template("statistics.html",
                           line_stats=line_stats,
                           type_counter=type_counter)


if __name__ == "__main__":
    app.run(debug=True)
