extends Node

var udp := PacketPeerUDP.new()
var connected := false

var player_id := 0
var ip := ""
var nick := ""

func start_connection(p_ip: String, p_nick: String):
	ip = p_ip
	nick = p_nick
	print("Start connection to ", ip)
	
	var err = udp.set_dest_address(ip, 2137)
	if err == OK:
		send_message("/join;" + nick)
		connected = true
	else:
		return_to_menu("Błąd połączenia")

func send_message(message: String):
	if connected:
		var data = (message + "\n").to_utf8_buffer()
		print("Sending: ", message)
		udp.put_packet(data)

func _process(delta):
	if connected:
		while udp.get_available_packet_count() > 0:
			var packet = udp.get_packet()
			var received = packet.get_string_from_utf8().strip_edges().split(";")
			if received.size() < 1:
				continue
			var type_of_data = received[0]
			if type_of_data == "J":
				player_id = int(received[1])
				print("Zarejestrowano jako ID: ", player_id)
				connected = false
				get_tree().change_scene("res://scenes/lobby.tscn")
			elif type_of_data == "E":
				var error_msg = received.size() > 1 and received[1] or "Nieznany błąd"
				connected = false
				return_to_menu(error_msg)

func return_to_menu(reason: String):
	print("Powrót do menu: ", reason)
	connected = false
	udp.close()
	Global.connection_error = reason
	Global.was_connecting = true
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
