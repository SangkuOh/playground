import Foundation

extension Data {
	var prettyPrintedJSONString: String {
		guard
			let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
			let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
			return self.description
		}
		
		return String(decoding: jsonData, as: UTF8.self)
	}
}

extension Data {
	mutating func appendString(_ string: String) {
		if let data = string.data(using: .utf8) {
			self.append(data)
		}
	}
}


