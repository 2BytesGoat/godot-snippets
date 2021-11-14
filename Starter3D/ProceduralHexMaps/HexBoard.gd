extends GridMap

var tile_size = null
var tile_height := 1
var num_colors := 1

export var hex_rows := 7
export var hex_cols := 5
export var hex_cols_min := 3

func _ready():
	tile_size = mesh_library.get_item_mesh(0).get_aabb().size
	tile_height = tile_size.z
	
	num_colors = len(mesh_library.get_item_list())
	cell_size.x = stepify(tile_height * cos(deg2rad(30)), 0.01)
	cell_size.z = tile_height / 2.0
	_generate_square_grid()

func _generate_square_grid():
	var x_shift = hex_cols * cell_size.x
	for y in range(hex_rows):
		var zc_range = _get_zero_centered_range(hex_cols)
		if y % 2:
			zc_range.pop_back()
		for x in zc_range:
			x = x * x_shift + y % 2
			set_cell_item(x, 0, y, y % num_colors)

func _generate_hex_grid():
	for step in range(3):
		var cols_min = hex_cols_min - max(step-1, 0)
		_fill_hex_grid(hex_cols-step, cols_min, step)

func _fill_hex_grid(_cols, min_cols, shift):
	for y in range(_cols - min_cols + 1):
		for x in _get_zero_centered_range(_cols - y):
			var x_shift = stepify(cell_size.x * (_cols - y) / 2, 0.01)
			var x_pos = x * x_shift * 2
			var y_pos = y * 3 + shift
			var mirror_color = 1 + shift % (num_colors - 1) if shift else shift
			set_cell_item(x_pos, 0,  y_pos, shift % num_colors)
			set_cell_item(x_pos, 0, -y_pos, mirror_color)

func _get_zero_centered_range(n: int):
	var array = []
	var shift = (n-1) / 2.0 
	if not shift:
		return [shift]
	for x in range(n):
		array.append((x - shift)/shift)
	return array
