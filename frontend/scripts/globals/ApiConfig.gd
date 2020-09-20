extends Node

var api_url = 'http://127.0.0.1:5000'
var api_password = ''
var username = ''
var password = ''
var token = ''

func _ready():
	load_config()


func save_config():
	var config = File.new()
	config.open("user://api_config.florin", File.WRITE)
	
	config.store_line(to_json({
		"username": username,
		"password": password
	}))
	
	config.close()


func load_config():
	var config = File.new()
	if config.file_exists("user://api_config.florin"):
		config.open("user://api_config.florin", File.READ)
		if config.get_position() < config.get_len():
			var data = parse_json(config.get_line())
			username = data.get('username', '')
			password = data.get('password', '')
	
	print("username: "+username)
	print("pswd: "+password)
	config.close()
