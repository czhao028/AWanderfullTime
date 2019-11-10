class Node:
    def __init__(self, **kwargs):
        print(kwargs)
        self.lat = kwargs["Lat"]
        self.lon = kwargs["Lon"]
        self.name = kwargs["Name"]
        self.routes = kwargs["Routes"]
        self.stopID = kwargs["StopID"]
        self.safety = 0
        self.children = []
        self.parent = None

    def set_safety(self, score):
        self.safety = score

    def set_child(self, node_child):
        self.children.append(node_child)
    def set_parent(self, node_parent):
        self.parent = node_parent


# {
#       "StopID": "4001090",
#       "Name": "KING STREET STA + BUS BAY B",
#       "Lon": -77.060615,
#       "Lat": 38.805954,
#       "Routes": ["29K", "29Kv1", "29N", "29Nv1"]
#     }
