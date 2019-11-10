import dill as pk
from lambda2 import *
import heapq
from geopy.distance import vincenty

from collections import Counter

closed_list = []
open_list = []
pq = []
# x = []
# y = []
stack = []
#radius = 0.25
with open("allstops.pk", "rb") as nodes_file:
    nodes_dict = pk.load(nodes_file)
with open("parentstops.pk", "rb") as edges_file:
    edges_dict = pk.load(edges_file)
def a_star(start_coords, end_coords, radius):
    starty, startx = start_coords
    endy, endx = end_coords
    starting_stops = stops_radius(**{"Lat": starty, "Lon": startx, "Radius": radius})
    ending_stops = stops_radius(**{"Lat": endy, "Lon": endx, "Radius": radius})

    end_IDS = {stop["StopID"]:0 for stop in ending_stops["Stops"]}
    print(ending_stops["Stops"])
    for stop in starting_stops["Stops"]:
        the_node = nodes_dict[stop["StopID"]]
        if type(the_node) is int: continue
        distance_end = vincenty((the_node.lat, the_node.lon), end_coords)
        the_node.h = distance_end.km + the_node.safety
        the_node.g = 0
        the_node.f = the_node.g + the_node.h
        heapq.heappush(pq, (the_node.f, the_node.stopID, the_node))

    print(pq)
    print("starting pq")

    while len(pq) != 0:
        print(len(pq))
        next_f, next_stopID, next_node = heapq.heappop(pq)
        x.append(next_node.lon)
        y.append(next_node.lat)
        print(end_IDS.get(next_node.stopID))
        if end_IDS.get(next_node.stopID) is not None:
            return next_node
        for f, stop_id, closed_node in closed_list:
            if closed_node == next_node:
                if closed_node.g < next_node.g:
                    print(closed_node)
                    print(next_node)
                    print("Smaller than closed")
                    break
        else:
            for child, distance in edges_dict[next_node.stopID].items():
                child_node = nodes_dict[child]
                new_g = next_node.g + distance.km
                #new_h = vincenty((child_node.lat, child_node.lon), end_coords).km + child_node.safety
                new_g +=  child_node.safety
                new_h = 0
                new_f = new_g + new_h
                for f, stop_id, open_node in open_list:
                    if open_node.g < new_f:
                        print("smaller than open")
                        break
                print("New g, h, f" + str([new_g, new_h, new_f]))
                print(distance)
                print("Old distance" + str(next_node.g))
                new_node = Node(**{"Lat":child_node.lat, "Lon": child_node.lon, "Name": child_node.name, "Routes": child_node.routes,
                                 "StopID": child_node.stopID})
                new_node.set_parent(next_node)
                new_node.set_safety(child_node.safety)
                new_node.g = new_g
                new_node.f = new_f
                new_node.h = new_h
                open_list.append((new_f, new_node.stopID, new_node))
            closed_list.append((next_f, next_stopID, next_node))

    return list() #never reached node

def any_lambda(iterable, function):
  return any(function(i) for i in iterable)

def routes_common(start_coords, end_coords, radius):
    starty, startx = start_coords
    endy, endx = end_coords
    starting_stops = stops_radius(**{"Lat": starty, "Lon": startx, "Radius": radius})
    ending_stops = stops_radius(**{"Lat": endy, "Lon": endx, "Radius": radius})

    routes = []
    for stop in starting_stops["Stops"]:
        routes.extend(stop['Routes'])
    for stop in ending_stops["Stops"]:
        routes.extend(stop['Routes'])

    c = Counter(routes)
    the_routes = sorted(c, key=c.get, reverse=True)
    limit_x = sorted([startx, endx])
    limit_y = sorted([starty, endy])

    for r in the_routes:
        path_det = path_details(r)
        print(r + "Route")
        if "Direction0" in path_det:
            path_det = path_det["Direction0"]
            break
        elif "Direction1" in path_det:
            path_det = path_det["Direction1"]
            break
    else:
        raise Exception("No routes found")

    array_lat = []
    array_lon = []

    appending = False
    ends = []
    for stop in path_det["Stops"]:
        lon = stop["Lon"]
        lat = stop["Lat"]
        sid = stop["StopID"]
        # for i in starting_stops["Stops"]:
        #     if i["StopID"] == sid:

        if any_lambda(starting_stops["Stops"], lambda x: x["StopID"] == sid) or any_lambda(ending_stops["Stops"], lambda x: x["StopID"] == sid):
            if not appending:
                ends.append(stop["StopID"])
                appending = True
            elif appending and stop["StopID"] not in ends:
                appending = False
            if appending:
                array_lat.append(lat)
                array_lon.append(lon)

    return (array_lat, array_lon)
# a = (38.897584, -77.016682)
a = (38.888871, -77.003902)
b = (38.888956, -76.972548)

y, x = routes_common(a, b, (vincenty(a,b).km)*1000/2)
# print((vincenty(a,b).km)*1000)
# end_node = a_star(a,b, (vincenty(a,b).km)*1000/2)

# print(end_node)
# node = end_node
# gps = []
# lot = []
# lng = []
# while type(end_node) != list and node.parent != None:
#     gps.append((node.lat, node.lon))
#     print(gps)
#     lot.append(node.lat)
#     lng.append(node.lon)
#     node = node.parent
# print(lot)
# print(lng)
                #if there is an element in open_dict with g<

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import gmplot
gmap2 = gmplot.GoogleMapPlotter(38.889192, -76.990424, 13)
gmap2.scatter( y, x, '# FF0000', marker = False )
gmap2.draw( "C:\\Users\\czhao\\Desktop\\map13.html" )

fig = plt.figure()
plt.xlim(min(x), max(x))
plt.ylim(min(y), max(y))

graph, = plt.plot([], [], 'o')
print(x)
print(y)
def animate(i):
    graph.set_data(x[:i+1], y[:i+1])
    return graph


ani = FuncAnimation(fig, animate, interval=500)
plt.show()




            # heapq.
            # if open_dict.get(child) != None:
            #     if new_g > child_node.g: continue
            # if closed_dict.get(child) != None:
            #     if new_g > child_node.g:
            #         child_node.g = new_g
            #         child_node.parent = next_node
            #         open_dict[child] = 0







