enum HttpHeader {
	case defaults
	case auth(accessToken: String? = nil)
	case form
}

extension HttpHeader {
	var headers: [String: String] {
		switch self {
		case .defaults:
			return [
				"Content-Type": "application/json;charset=UTF-8"
			]
			
		case .auth(let accessToken):
			return [
				"Content-Type": "application/json;charset=UTF-8",
				"Authorization": "Bearer \(accessToken ?? Token.access.tokenString)"
			]

		case .form:
			return [
				"Content-Type": "application/x-www-form-urlencoded",
				"Authorization": "Bearer \(Token.access.tokenString)"
			]
		}
	}
}


