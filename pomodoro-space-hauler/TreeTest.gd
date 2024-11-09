extends Control

@onready var tree = $Tree

# Sample data for the list
var items = [
	{"name": "Apple", "price": 1.20, "quantity": 10},
	{"name": "Banana", "price": 0.75, "quantity": 20},
	{"name": "Cherry", "price": 2.50, "quantity": 5},
]

# Sorting settings
var current_sort_column = 0  # Start with the first column
var sort_ascending = true

func _ready():
	# Configure the Tree
	tree.columns = 3
	tree.hide_root = true
	tree.set_column_title(0, "Name")
	tree.set_column_title(1, "Price")
	tree.set_column_title(2, "Quantity")
	tree.connect("cell_selected", Callable(self, "_on_tree_cell_selected"))
	
	# Load and display the items
	update_tree()

# Function to update the Tree with sorted items
func update_tree():
	tree.clear()
	var root = tree.create_item()  # Root node for the tree
	
	# Sort items by the selected column
	items.sort_custom(Callable(self, "_sort_items"))
	
	# Populate the Tree with sorted items
	for item_data in items:
		var item = tree.create_item(root)
		item.set_text(0, item_data["name"])
		item.set_text(1, "%.2f" % item_data["price"])
		item.set_text(2, str(item_data["quantity"]))

# Custom sorting function based on the selected column
func _sort_items(a, b):
	var column_key = get_column_key(current_sort_column)
	if sort_ascending:
		return int(a[column_key] > b[column_key])
	else:
		return int(a[column_key] < b[column_key])

# Map column indices to data keys
func get_column_key(column: int) -> String:
	match column:
		0: return "name"
		1: return "price"
		2: return "quantity"
	return "name"  # Default case

# Called when a column header is clicked
func _on_tree_cell_selected(column: int):
	if current_sort_column == column:
		# Toggle ascending/descending if the same column is selected
		sort_ascending = !sort_ascending
	else:
		# Set the new column and reset to ascending
		current_sort_column = column
		sort_ascending = true
	
	# Update the Tree display with sorted data
	update_tree()
