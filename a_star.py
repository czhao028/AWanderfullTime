import dill as pk
from lambda2 import *
import heapq
from geopy.distance import vincenty


closed_list = []
open_list = []
pq = []
x = []
y = []
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
        the_node.h = distance_end
        the_node.g = 0
        the_node.f = the_node.g + the_node.h.km
        heapq.heappush(pq, (the_node.f, the_node.stopID, the_node))

    print(pq)
    print("starting pq")

    while len(pq) != 0:
        next_f, next_stopID, next_node = heapq.heappop(pq)
        x.append(next_node.lon)
        y.append(next_node.lat)
        if end_IDS.get(next_node.stopID) != None:
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
                new_h = vincenty((child_node.lat, child_node.lon), end_coords).km
                new_f = new_g + new_h
                for f, stop_id, open_node in open_list:
                    if open_node.g < new_f: break
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
# a = (38.897584, -77.016682)
a = (38.888871, -77.003902)
b = (38.888956, -76.972548)
print((vincenty(a,b).km)*1000)
end_node = a_star(a,b, (vincenty(a,b).km)*1000/2)

print(end_node)
node = end_node
gps = []
lot = []
lng = []
while type(end_node) != list and node.parent != None:
    gps.append((node.lat, node.lon))
    print(gps)
    lot.append(node.lat)
    lng.append(node.lon)
    node = node.parent
print(lot)
print(lng)
                #if there is an element in open_dict with g<

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

fig = plt.figure()
plt.xlim(-77.06, -77.04)
plt.ylim(38.88, 39.00)

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







