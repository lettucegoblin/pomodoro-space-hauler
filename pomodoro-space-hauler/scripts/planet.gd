class_name Planet

var name = ""
var cluster = ""
var resources = []
var special_features = []
var hazards = []
var trade_goods = []


func _init(name, cluster, resources = [], special_features = [], hazards = [], trade_goods = []):
  self.name = name
  self.cluster = cluster
  self.resources = resources
  self.special_features = special_features
  self.hazards = hazards
  self.trade_goods = trade_goods
  print("Planet initialized: " + name)

func get_name():
  return name

func get_cluster():
  return cluster

func get_resources():
  return resources

func get_special_features():
  return special_features

func get_hazards():
  return hazards

func get_trade_goods():
  return trade_goods
  