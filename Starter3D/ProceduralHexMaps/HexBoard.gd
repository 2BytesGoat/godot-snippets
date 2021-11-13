extends GridMap

const TILE_HEIGHT := 1
var num_colors := 1

export var hex_rows := 7
export var hex_cols := 5

func _ready():
	num_colors = len(mesh_library.get_item_list())
	cell_size.x = stepify(TILE_HEIGHT * cos(deg2rad(30)), 0.01)
	cell_size.z = TILE_HEIGHT / 2.0
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

func _get_zero_centered_range(n: int):
	var array = []
	var shift = (n-1) / 2.0 
	if not shift:
		return [shift]
	for x in range(n):
		array.append((x - shift)/shift)
	return array
