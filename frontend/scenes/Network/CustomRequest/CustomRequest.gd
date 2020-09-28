tool
extends HTTPRequest

export(String, 'GET','POST','PUT','DELETE') var type = 'GET' setget _set_type
func _set_type(value):
	type = value
	match(type):
		'GET': _true_type = HTTPClient.METHOD_GET
		'POST': _true_type = HTTPClient.METHOD_POST
		'PUT': _true_type = HTTPClient.METHOD_PUT
		'DELETE': _true_type = HTTPClient.METHOD_DELETE
export(String) var route = '/'

var _true_type = 0

func send(request_dict, username="", password=""):
	var query = JSON.print(request_dict)
	var auth=str("Basic ", Marshalls.utf8_to_base64(str(username, ":", password)))
	var headers = ["Content-Type: application/json","Authorization: "+auth]
	var url = ApiConfig.api_url+route
	return request(url, headers, false, _true_type, query)
