class_name Planet

var name = ""
var cluster: Cluster = null
var resources = []
var special_features = []
var hazards = []
var trade_goods = []
var color = Color(1, 1, 1)
var size :float = 1.0 # 0.5 to 1.0

func _init(p_name, p_cluster):
  self.name = p_name
  self.cluster = p_cluster
  print("Planet initialized: " + p_name)

func get_name():
  return name

func get_cluster() -> Cluster:
  return cluster

func get_resources():
  return resources

func get_special_features():
  return special_features

func get_hazards():
  return hazards

func get_trade_goods():
  return trade_goods

func get_color():
  return color
  
