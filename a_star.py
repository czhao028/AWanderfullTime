import dill as pk
from lambda2 import *
import heapq
from geopy.distance import vincenty

closed_dict = dict()
open_dict = dict()
pq = []
#radius = 0.25
def a_star(start_coords, end_coords, radius):
    with open("allstops.pk", "rb") as nodes_file:
        nodes_dict = pk.load(nodes_file)
    with open("parentstops.pk") as edges_file:
        edges_dict = pk.load(edges_file)
    starty, startx = start_coords
    endy, endx = end_coords
    starting_stops = stops_radius(**{"Lat": starty, "Lon": startx, "Radius": radius})
    ending_stops = stops_radius(**{"Lat": endy, "Lon": endx, "Radius": radius})
    end_IDS = {stop["StopID"]:0 for stop in ending_stops}
    for stop in starting_stops["Stops"]:
        the_node = nodes_dict[stop["StopID"]]
        heapq.heappush(pq, (vincenty((the_node.lat, the_node.lon), end_coords), the_node.stopID, the_node))
        open_dict[the_node.stopID] = vincenty((the_node.lat, the_node.lon), end_coords)

    while len(pq) != 0:
        next_node = heapq.heappop(pq)
        del open_dict[next_node]
        closed_dict[next_node] = 0
        for child in next_node.children:
            



