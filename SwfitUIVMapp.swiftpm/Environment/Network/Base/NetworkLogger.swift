import Foundation

class NetworkLogger {
	static func log(request: URLRequest) {
		print("\n\n - - - - - - - - - - [[ 📮📮📮 URLRequest 📮📮📮 ]] - - - - - - - - - - \n")
		
		guard
			let urlAsString = request.url?.absoluteString,
			let method = request.httpMethod else {
			return
		}
		
		let urlComponents = URLComponents(string: urlAsString)
		
		guard
			let host = urlComponents?.host,
			let path = urlComponents?.path else {
			return
		}
		
		let query = urlComponents?.query ?? ""
		
		var output = """
		\(urlAsString)
		\(method) \(path)?\(query)
		HOST: \(host)\n
		"""
		
		output += "\n-- Request Header --\n"
		for (key, value) in request.allHTTPHeaderFields ?? [:] {
			output += "\(key): \(value) \n"
		}
		
		output += "\n-- Request Body --\n"
		if let body = request.httpBody {
			output += body.prettyPrintedJSONString
		} else {
			output += "NONE"
		}
		output += "\n"
		print(output)
	}
	
	static func log(response: HTTPURLResponse?, data: Data?, error: Error? = nil) {
		print("\n\n - - - - - - - - - - [[ 🚛🚛🚛 URLResponse 🚛🚛🚛 ]] - - - - - - - - - - \n")
		
		guard
			let urlString = response?.url?.absoluteString,
			let components = URLComponents(string: urlString) else {
			return
		}
		
		let path = components.path
		let query = components.query ?? ""
		var output = ""
		
		if let statusCode = response?.statusCode {
			var emoji: String {
				switch statusCode {
				case 200...209:
					return "✅"
					
				default:
					return "🚨"
				}
			}
			output += "\(emoji) HTTP \(statusCode) \(path)?\(query)\n"
		}
		
		if let data {
			output += "\n-- Response body --\n"
			output += data.prettyPrintedJSONString
		}
		
		if let error {
			output += "\nError: \(error.localizedDescription)"
		}
		print(output)
	}
}


