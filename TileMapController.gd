extends TileMap

var is_stop := false

func _input(event: InputEvent) -> void:
	var lc = local_to_map(get_global_mouse_position())
	if event.is_action_released("die_tile") and get_cell_atlas_coords(0, lc) == Vector2i(0,0):
		set_cell(0, lc, 0, Vector2i(1,0))
	elif event.is_action_released("die_tile") and get_cell_atlas_coords(0, lc) != Vector2i(0,0):
		set_cell(0, lc, 0, Vector2i(0,0))
	
	if not is_stop and event.is_action_released("change_speed"):
		is_stop = true
		$"../Timer".stop()
		$"../UICanvas/UI/MarginContainer/HBoxContainer/StatePauseTexture".texture = load("res://pause.png")
	elif is_stop and event.is_action_released("change_speed"):
		is_stop = false
		$"../Timer".start()
		$"../UICanvas/UI/MarginContainer/HBoxContainer/StatePauseTexture".texture = load("res://play.png")

func stroke() -> void:
	for i in get_used_cells(1):
		set_cell(0, i, 0, get_cell_atlas_coords(1, i))
	
	clear_layer(1)
	
	for i in get_used_cells_by_id(0, 0, Vector2i(1,0)):
		var counter := 0
		var coordinates_neighbour:Array[Vector2i] = [i+Vector2i.RIGHT, i+Vector2i.LEFT, i+Vector2i.UP, i+Vector2i.UP+Vector2i.RIGHT, i+Vector2i.UP+Vector2i.LEFT, i+Vector2i.DOWN, i+Vector2i.DOWN+Vector2i.RIGHT, i+Vector2i.DOWN+Vector2i.LEFT]
		
		for j in coordinates_neighbour:
			if get_cell_atlas_coords(0, j) == Vector2i(1,0):
				counter += 1
	
		if counter < 2 or counter > 3:
			set_cell(1, i, 0, Vector2i.ZERO)
	
	for i in get_used_cells_by_id(0, 0, Vector2i(0,0)):
		var counter := 0
		var coordinates_neighbour:Array[Vector2i] = [i+Vector2i.RIGHT, i+Vector2i.LEFT, i+Vector2i.UP, i+Vector2i.UP+Vector2i.RIGHT, i+Vector2i.UP+Vector2i.LEFT, i+Vector2i.DOWN, i+Vector2i.DOWN+Vector2i.RIGHT, i+Vector2i.DOWN+Vector2i.LEFT]
		
		for j in coordinates_neighbour:
			if get_cell_atlas_coords(0, j) == Vector2i(1,0):
				counter += 1
			
		if counter == 3:
			set_cell(1, i, 0, Vector2i(1,0))

func _on_timer_timeout() -> void:
	print("UPDATE")
	stroke()

