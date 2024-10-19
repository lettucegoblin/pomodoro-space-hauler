class_name Cluster

var name: String = ""
var planets: Array[Planet] = []

func _init(name: String, planets: Array[Planet] = []):
  self.name = name
  self.planets = planets
  print("Cluster initialized: " + name)

func add_planet(planet: Planet):
  planets.append(planet)

func get_planets():
  return planets

func get_name():
  return name
