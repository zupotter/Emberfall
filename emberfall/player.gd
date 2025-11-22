extends Node2D

var inventory := []                # simple list of item names
var inventory_open := false
var equipped_item = ""
var selected_index := 0



@onready var inventory_label = $InventoryLabel

func _ready():
	# hide label initially
	inventory_label.visible = false
	print("Player loaded. Inventory:", inventory)

func _process(delta):
	# Add item on Enter (ui_accept)
	if Input.is_action_just_pressed("ui_accept"):
		add_item("Iron Sword")
	if Input.is_action_just_pressed("use_item"):
		use_item()
	# Move selection down
	if Input.is_action_just_pressed("ui_down"):
		selected_index += 1
		if selected_index >= inventory.size():
			selected_index = 0
		update_inventory_ui()
		
	# Move Selection up
	if Input.is_action_just_pressed("ui_up"):
		selected_index -= 1 
		if selected_index < 0:
			selected_index = inventory.size() - 1
		update_inventory_ui()

	# Toggle inventory on I 
	if Input.is_action_just_pressed("toggle_inventory"):
		inventory_open = not inventory_open
		update_inventory_ui()
		
	if Input.is_action_just_pressed("drop_item"):
		drop_item()

func add_item(item_name: String) -> void:
	inventory.append(item_name)
	print(item_name, " added!")
	update_inventory_ui()

func update_inventory_ui() -> void:
	if inventory_open:
		inventory_label.visible = true
		# build the text: Inventory: on top, each item on its own line
		
		if inventory.size() == 0:
			inventory_label.text = "Inventory:\n( empty )"
		else:
			var text = "Inventory:\n"
			for i in range(inventory.size()):
				if i == selected_index:
					text += "> " + inventory[i] + "\n" # highlights the selected item
				else:
					text += inventory[i] + "\n"
			inventory_label.text = text
	else:
		inventory_label.visible = false

func use_item():
	if inventory.size() == 0:
		print("Inventory is empty!")
		return

	var item = inventory[selected_index]
	equipped_item = item
	print("Equipped item: " + equipped_item)

func drop_item():
	if inventory.size() == 0:
		print("Inventory is empty!")
		return
	
	var item = inventory[selected_index]
	inventory.remove_at(selected_index)
	print(item + " dropped!")
	
	if inventory.size() == 0:
		selected_index = 0
	elif selected_index >= inventory.size():
		selected_index = inventory.size() - 1
		
	update_inventory_ui()	
	
	
