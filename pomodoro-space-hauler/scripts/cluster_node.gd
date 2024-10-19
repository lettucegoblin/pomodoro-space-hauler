extends Node2D

class_name ClusterNode

var cluster: Cluster
var PlanetNode = preload("res://scenes/planet_scene.tscn")
# Initialize the node with a cluster
func _initialize(cluster: Cluster):
	self.cluster = cluster
	set_name(cluster.get_name())  # Set the node name to the cluster name
	add_planets()  # Add planets to the cluster node

# Add planets to the cluster node as children
func add_planets():
	for planet in cluster.get_planets():
		var planet_node = PlanetNode.instantiate()
		planet_node.planet_data = planet
		add_child(planet_node)
