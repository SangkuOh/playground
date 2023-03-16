enum TestEndpoint: Endpoint {
	case getUser
}

extension TestEndpoint {
	var path: String {
		switch self {
		case .getUser:
			return "api/test/user"
		}
	}
	
	var method: RequestMethod {
		switch self {
		case .getUser:
			return .get
		}
	}
	
	var query: [String: String]? {
		switch self {
		default:
			return nil
		}
	}
	
	var body: Encodable? {
		switch self {
		default:
			return nil
		}
	}
	
	var header: [String: String]? {
		switch self {
		default:
			return HttpHeader.auth().headers
		}
	}
}

