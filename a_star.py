import dill as pk
from .lambda2 import *
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
        distance_end = vincenty((the_node.lat, the_node.lon), end_coords)
        the_node.h = distance_end
        the_node.g = 0
        the_node.f = the_node.g + the_node.h.kilometers
        heapq.heappush(pq, (the_node.f, the_node.stopID, the_node))
        open_dict[the_node.stopID] = 0 #placeholder

    while len(pq) != 0:
        next_node = heapq.heappop(pq)
        if ending_stops.get(next_node) != None:
            return next_node
        del open_dict[next_node]
        closed_dict[next_node] = 0
        for child, distance in edges_dict[next_node.stopID].items():
            child_node = nodes_dict[child]
            new_g = next_node.g + distance
            new_h = vincenty((next_node.lat, next_node.lon), (child_node.lat, child_node.lon)).kilometers
            new_f = new_g + new_h

            heapq.
            if open_dict.get(child) != None:
                if new_g > child_node.g: continue
            if closed_dict.get(child) != None:
                if new_g > child_node.g:
                    child_node.g = new_g
                    child_node.parent = next_node
                    open_dict[child] = 0







