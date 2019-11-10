import sklearn
import openpyxl
import numpy as np
import pandas as pd
import pickle as pk
from sklearn.metrics.pairwise import pairwise_distances
from sklearn.cluster import DBSCAN
from geopy.distance import vincenty

import time

def distance_in_meters(x, y):
    return vincenty((x[0], x[1]), (y[0], y[1])).m


if __name__ == "__main__":
    t1 = time.time()
    try:
        with open("crime.pk", "rb") as file:
            xl = pk.load(file)
    except:
        xl = pd.read_csv("dc_crime_add_vars.csv")
        with open("crime.pk", "wb") as file:
            pk.dump(xl, file)

    x1 = xl[xl["year"] == 2017]
    matrix_dbscan = []
    for i, j in x1.iterrows():
        matrix_dbscan.append((j["XBLOCK"],j["YBLOCK"])) #xblock is longitude, yblock is latitude
    matrix_dbscan = np.array(matrix_dbscan)
    print("finished appending")
    print(matrix_dbscan)
    distance_matrix = pairwise_distances(matrix_dbscan, metric=distance_in_meters)
    print(distance_matrix)
    with open("distances.pk") as dist:
        pk.dump(distance_matrix, dist)
    dbscan = DBSCAN(metric='precomputed', eps=2000, min_samples=2)
    clustering = dbscan.fit(distance_matrix)
    print(set(clustering.labels_))


    print(time.time()-t1)