extends Node3D


var scramble:String
var turn_speed:float = 0.3
@export var scramble_info:LineEdit
@export var input_control:GridContainer
@export var btn_scramble:Button
@export var btn_solve:Button


var rubik_face = [
	[[0, 1, 2], [3, 4, 5], [6, 7, 8]],
	[[9, 10, 11], [12, 13, 14], [15, 16, 17]],
	[[18, 19, 20], [21, 22, 23], [24, 25, 26]],
	[[27, 28, 29], [30, 31, 32], [33, 34, 35]],
	[[36, 37, 38], [39, 40, 41], [42, 43, 44]], 
	[[45, 46, 47], [48, 49, 50], [51, 52, 53]]]

var rubik_face_id = [
	[0,1,2,3,4,5,6,7,8],
	[0,1,2,3,4,5,6,7,8],
	[0,1,2,3,4,5,6,7,8],
	[0,1,2,3,4,5,6,7,8],
	[0,1,2,3,4,5,6,7,8],
	[0,1,2,3,4,5,6,7,8],
	]

var rubik_sovle = [
	# Mặt trên
	[Color(1, 1, 1), Color(1, 1, 1), Color(1, 1, 1),
	Color(1, 1, 1), Color(1, 1, 1), Color(1, 1, 1),
	Color(1, 1, 1), Color(1, 1, 1), Color(1, 1, 1),],
	
	# Mặt dưới
	[Color(0,0,0), Color(0,0,0), Color(0,0,0),
	Color(0,0,0), Color(0,0,0), Color(0,0,0),
	Color(0,0,0), Color(0,0,0), Color(0,0,0),],
	
	# Mặt trước
	[Color(1, 0, 0), Color(1, 0, 0), Color(1, 0, 0),
	Color(1, 0, 0), Color(1, 0, 0), Color(1, 0, 0),
	Color(1, 0, 0), Color(1, 0, 0), Color(1, 0, 0),],
	
	# Mặt sau
	[Color(0, 1, 0), Color(0, 1, 0), Color(0, 1, 0),
	Color(0, 1, 0), Color(0, 1, 0), Color(0, 1, 0),
	Color(0, 1, 0), Color(0, 1, 0), Color(0, 1, 0),],
	
	# Mặt trái
	[Color(0, 0, 1), Color(0, 0, 1), Color(0, 0, 1),
	Color(0, 0, 1), Color(0, 0, 1), Color(0, 0, 1),
	Color(0, 0, 1), Color(0, 0, 1), Color(0, 0, 1),],
	
	# Mặt phải
	[Color(1, 1, 0), Color(1, 1, 0), Color(1, 1, 0),
	Color(1, 1, 0), Color(1, 1, 0), Color(1, 1, 0),
	Color(1, 1, 0), Color(1, 1, 0), Color(1, 1, 0)]
]

var rubik_block:Array

# Hàm tráo mặt giữa các khối Rubik
func shuffle_blocks_face(face_index: int, clockwise: bool):
	# Xác định các khối Rubik liên quan đến mặt cần tráo
	var blocks = get_blocks_of_face(face_index)
	
	# Thực hiện di chuyển trên mỗi khối Rubik
	for block in blocks:
		block.shuffle_face(face_index, clockwise)

# Hàm lấy ra các khối Rubik liên quan đến mặt cần tráo
func get_blocks_of_face(face_index: int) -> Array:
	var blocks = []

	# Duyệt qua tất cả các khối Rubik và lọc ra các khối Rubik liên quan đến mặt cần tráo
	for block in rubik_block:
		if block.is_face_related(face_index):
			blocks.append(block)

	return blocks

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scramble = scramble_info.text
	btn_solve.connect("pressed", _on_btn_rubik_solve)
	btn_scramble.connect("pressed", rubik_run_scramble)
	scramble_info.connect("text_changed", _on_scramble_text_changed)
	
	var all_turn:Array = ["U","U'","D","D'","F","F'","B","B'","L","L'","R","R'","M","M'","E","E'","S","S'"]
	for i in input_control.get_child_count():
		var child:Button = input_control.get_child(i)
		child.text = all_turn[i]
		
		child.connect("pressed",rubik_move.bind(all_turn[i]))
	
	var new_colors = [
		Color.WHITE, Color.YELLOW, Color.GREEN,
		Color.BLUE, Color.DARK_ORANGE, Color.RED
	]
	for i in range(rubik_sovle.size()):
		for j in range(rubik_sovle[i].size()):
			rubik_sovle[i][j] = new_colors[i]
	_on_btn_rubik_solve()
	
	await get_tree().create_timer(1).timeout
	
	#rubik_move(5,false)
	#for i in 100:
		#rubik_move(5,false)
		#await get_tree().create_timer(0.5).timeout
	#await get_tree().create_timer(1).timeout
	#for i in randi_range(50,100):
		#var turn_id:int = randi_range(0,8)
		#var clockwise:bool
		#if randi_range(0,1) == 0:
			#clockwise = false
		#else:
			#clockwise = true
		#rubik_move(turn_id,clockwise)
		#await get_tree().create_timer(0.4).timeout
		#prints(i, turn_id, clockwise)
	#rubik_run_scramble(rubik_convert_scramble(),0.3)

func _on_scramble_text_changed(new_text:String):
	scramble = new_text

func _on_btn_rubik_solve():
	rubik_block = rubik_sovle.duplicate(true)
	set_color(false)

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		self.rotation_degrees.y -= 50 * delta
	if Input.is_action_pressed("ui_left"):
		self.rotation_degrees.y += 50 * delta
	if Input.is_action_pressed("ui_up"):
		self.rotation_degrees.x -= 50 * delta
	if Input.is_action_pressed("ui_down"):
		self.rotation_degrees.x += 50 * delta

func rubik_convert_scramble() -> Array:
	var convert_move:Array = []
	convert_move = scramble.split(" ")
	prints("Scramble",scramble)
	
	var conver_move2:Array
	for i in convert_move.size():
		if "2" in convert_move[i]:
			conver_move2.append(convert_move[i].left(-1))
			conver_move2.append(convert_move[i].left(-1))
		else:
			conver_move2.append(convert_move[i])
	
	return conver_move2

func rubik_run_scramble(time:float = 0.2):
	var all_turn = rubik_convert_scramble()
	for i in all_turn.size():
		prints("Turn", i)
		rubik_move(all_turn[i])
		await get_tree().create_timer(turn_speed).timeout

func rubik_move(move_id:String = "U"):
	var face_index: int = 0
	var clockwise: bool = true
	var turn:Array = []
	match move_id:
		"U":
			turn = [0,true]
		"U'":
			turn = [0,false]
		"D":
			turn = [1,true]
		"D'":
			turn = [1,false]
		"F":
			turn = [2,true]
		"F'":
			turn = [2,false]
		"B":
			turn = [3,true]
		"B'":
			turn = [3,false]
		"L":
			turn = [4,false]
		"L'":
			turn = [4,true]
		"R":
			turn = [5,true]
		"R'":
			turn = [5,false]
		"M":
			turn = [6,true]
		"M'":
			turn = [6,false]
		"E":
			turn = [7,true]
		"E'":
			turn = [7,false]
		"S":
			turn = [8,true]
		"S'":
			turn = [8,false]
	face_index = turn[0]
	clockwise = turn[1]
	prints(move_id, face_index, clockwise)
	
	var rubik = [
		#T
		[0,[2,5,3,4],[2,4,3,5],[[0,1,2],[0,1,2],[0,1,2],[0,1,2]]],
		#D
		[1,[2,4,3,5],[2,5,3,4],[[6,7,8],[6,7,8],[6,7,8],[6,7,8]]],
		#F
		[2,[0,4,1,5],[0,5,1,4],[[8,7,6],[2,5,8],[0,1,2],[6,3,0]]],
		#B
		[3,[0,5,1,4],[0,4,1,5],[[0,1,2],[2,5,8],[8,7,6],[6,3,0]]],
		#L
		[4,[0,2,1,3],[0,3,1,2],[[0,3,6],[0,3,6],[0,3,6],[8,5,2]]],
		#R
		[5,[0,2,1,3],[0,3,1,2],[[2,5,8],[2,5,8],[2,5,8],[6,3,0]]],
		#M
		[4,[0,3,1,2],[0,2,1,3],[[7,4,1],[7,4,1],[7,4,1],[1,4,7]]],
		#E
		[0,[2,4,3,5],[2,5,3,4],[[5,4,3],[5,4,3],[5,4,3],[5,4,3]]],
		#S
		[2,[0,4,1,5],[0,5,1,4],[[5,4,3],[1,4,7],[3,4,5],[7,4,1]]],
	]
	var face:int = rubik[face_index][0]
	if face_index < 6:
		if face_index == 4:
			if clockwise == true:
				clockwise = false
			else:
				clockwise = true
		var temp = rubik_block[face].duplicate(true)
		var temp_id = rubik_face_id[face].duplicate(true)
		if clockwise == true:
			rubik_block[face][0] = temp[6]
			rubik_block[face][1] = temp[3]
			rubik_block[face][2] = temp[0]
			rubik_block[face][3] = temp[7]
			rubik_block[face][5] = temp[1]
			rubik_block[face][6] = temp[8]
			rubik_block[face][7] = temp[5]
			rubik_block[face][8] = temp[2]
			
			rubik_face_id[face][0] = temp_id[6]
			rubik_face_id[face][1] = temp_id[3]
			rubik_face_id[face][2] = temp_id[0]
			rubik_face_id[face][3] = temp_id[7]
			rubik_face_id[face][5] = temp_id[1]
			rubik_face_id[face][6] = temp_id[8]
			rubik_face_id[face][7] = temp_id[5]
			rubik_face_id[face][8] = temp_id[2]
		else:
			rubik_block[face][0] = temp[2]
			rubik_block[face][1] = temp[5]
			rubik_block[face][2] = temp[8]
			rubik_block[face][3] = temp[1]
			rubik_block[face][5] = temp[7]
			rubik_block[face][6] = temp[0]
			rubik_block[face][7] = temp[3]
			rubik_block[face][8] = temp[6]
			
			rubik_face_id[face][0] = temp_id[2]
			rubik_face_id[face][1] = temp_id[5]
			rubik_face_id[face][2] = temp_id[8]
			rubik_face_id[face][3] = temp_id[1]
			rubik_face_id[face][5] = temp_id[7]
			rubik_face_id[face][6] = temp_id[0]
			rubik_face_id[face][7] = temp_id[3]
			rubik_face_id[face][8] = temp_id[6]
	
	var new_rubik_block = rubik_block.duplicate(true)
	var check:Array
	if face_index == 4:
		if clockwise == true:
			clockwise = false
		else:
			clockwise = true
	if clockwise == true:
		check = rubik[face_index][1]
	else:
		check = rubik[face_index][2]
		var new_arr:Array
		new_arr.append(rubik[face_index][3][0])
		new_arr.append(rubik[face_index][3][3])
		new_arr.append(rubik[face_index][3][2])
		new_arr.append(rubik[face_index][3][1])
		rubik[face_index][3] = new_arr
		
	var temp = rubik_block[check[0]].duplicate(true)
	for i in check.size():
		for j in 3:
			var index = rubik[face_index][3][i][j]
			#prints(check[i], index)
			if i+1 < 4:
				var temp_index = rubik[face_index][3][i+1][j]
				rubik_block[check[i]][index] = new_rubik_block[check[i+1]][temp_index]
			else:
				var temp_index = rubik[face_index][3][0][j]
				rubik_block[check[i]][index] = new_rubik_block[check[0]][temp_index]
	set_color(true)

func set_color(tween:bool = true):
	for i in get_child_count():
		var face:MeshInstance3D = get_child(i)
		var num:Sprite3D = get_child(i).get_child(0)
		var id:int = int(i % 9)
		var index:int = int(i / 9)
		var data = rubik_block[index][id]
		num.frame = rubik_face_id[index][id]
		var old_color:Color
		if face.material_override != null:
			old_color = face.material_override.albedo_color
		var mat:StandardMaterial3D = StandardMaterial3D.new()
		mat.albedo_color = old_color
		face.material_override = mat
		if tween == true:
			tween_color(mat,data)
		else:
			mat.albedo_color = data

func tween_color(obj, new_color:Color):
	var tween = get_tree().create_tween()
	tween.tween_property(obj, "albedo_color", new_color, turn_speed*60/100).set_trans(Tween.TRANS_BOUNCE)
