extends Node2D
var game_running := true

@export 
var player : Player
@export 
var PlayerScene: PackedScene

var players := {}

func _ready():
	player.player_id = Global.player_id
	player.position.x = Global.x
	player.position.y = Global.y
	player.connect("collided_with_player", Callable(self, "_on_player_collided"))
	

func send_message(message: String):
	if Global.connected:
		var data = (message + "\n").to_utf8_buffer()
		print("Sending: ", message)
		Global.udp.put_packet(data)

func send_data_to_server():
	if Global.connected and player:
		var pos_str = "P;%d;%d;%f;%f" % [player.player_id, player.current_role, player.position.x, player.position.y]
		var data = pos_str.to_utf8_buffer()
		print(pos_str)
		Global.udp.put_packet(data)

func _on_player_collided(victim_id: int) -> void:
	print("Collision detected with player:", victim_id)
	send_collision_to_server(victim_id)

func get_data_from_server():
	var packet = Global.udp.get_packet()
	var received = packet.get_string_from_utf8()
	received = received.split(";") 
	print("Received from server: ", received)
	
	# type_of_data
	# [P] position & role -> data_type;id;role;pos_x;pos_y
	# [J] player joined -> data_type;id
	# [D] player disconnected -> data_type;id
	
	var type_of_data = String(received[0]) #idk dlaczego nie mogę po prostu użyć chara
	
	if type_of_data == "P":
		var player_chunks = received[1].split("|")

		for chunk in player_chunks:
			var parts = chunk.split(",")
			if parts.size() != 4:
				continue  # zignoruj błędne dane

			var current_id = int(parts[0])
			var current_role = int(parts[1])
			var current_x = float(parts[2])
			var current_y = float(parts[3])

			if current_id == player.player_id:
				player.set_role(current_role)
				continue

			if players.has(current_id):
				var existing_player: Player = players[current_id]
				existing_player.position = Vector2(current_x, current_y)
				existing_player.set_role(current_role)
			else:
				var new_player := PlayerScene.instantiate() as Player
				new_player.player_id = current_id
				new_player.current_role = current_role
				new_player.position = Vector2(current_x, current_y)
				add_child(new_player)
				new_player.connect("collided_with_player", Callable(self, "_on_player_collided"))
				players[current_id] = new_player
		
	elif type_of_data == "G":
		game_running = false
		print("GAME OVER!")
		
	elif(type_of_data == "D"): #TODO player disconnect 
		pass

func send_collision_to_server(target_player_id: int):
	var msg = "C;%d;%d" % [player.player_id, target_player_id]
	send_message(msg)

func _process(delta):
	if Global.connected:
		while Global.udp.get_available_packet_count() > 0:
			get_data_from_server()
		if game_running:
			send_data_to_server() #TODO
