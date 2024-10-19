class_name Route

var starting_planet: Planet
var ending_planet: Planet

func starting_cluster() -> Cluster:
	return starting_planet.get_cluster()

func ending_cluster() -> Cluster:
	return ending_planet.get_cluster()

func print_route():
	print("Route from " + starting_planet.get_name() + " to " + ending_planet.get_name())
	print("Starting cluster: " + starting_cluster().get_name())
	print("Ending cluster: " + ending_cluster().get_name())
	var path = find_path_between_planets(starting_planet, ending_planet)
	print("Distance: ", len(path))
	var pathString = ""
	for cluster in path:
		pathString += cluster.get_name() + " -> "
	
	if len(pathString) > 0:
		pathString = pathString.left(len(pathString) - 4)
	print("Path: " + pathString)
	

func find_path_between_planets(start_planet: Planet, end_planet: Planet) -> Array[Variant]:
		# If both planets are in the same cluster, return []
		if start_planet.get_cluster() == end_planet.get_cluster():
				return [start_planet.get_cluster()]

		var start_cluster = start_planet.get_cluster()
		var end_cluster = end_planet.get_cluster()

		# BFS variables
		
		var queue = [] #    Array[Array[Cluster]] (queue of paths)
		var visited = {} #  Dictionary[Cluster, bool] (visited clusters)
		
		# Initialize queue with the start cluster
		queue.append([start_cluster])
		visited[start_cluster] = true

		while queue.size() > 0:
				var path = queue.pop_front()
				var current_cluster = path[path.size() - 1]

				# Check if we reached the end cluster
				if current_cluster == end_cluster:
						return path

				# Add neighbors to the queue
				for neighbor in current_cluster.get_neighbors():
						if neighbor not in visited:
								visited[neighbor] = true
								var new_path = path.duplicate()
								new_path.append(neighbor)
								queue.append(new_path)

		# Return an empty array if no path is found (which shouldn't happen if clusters are all connected)
		return []
