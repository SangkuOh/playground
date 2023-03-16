import Foundation

enum RequestError: Error, LocalizedError {
	case decode(Error)
	case invalidURL
	case noResponse
	case unauthorized
	case unexpectedStatusCode(ErrorResponse)
	case unknown(String?)
	
	var customMessage: String {
		switch self {
		case .decode(let error):
			return "Decode error\n\(error)"
			
		case .invalidURL:
			return "invalidURL"
			
		case .unauthorized:
			return "Session expired"
			
		case .noResponse:
			return "no response"
			
		case .unexpectedStatusCode(let error):
			return error.message
			
		case .unknown(let message):
			return message?.description ?? "no message"
		}
	}
	
	var status: Int {
		switch self {
		case .unauthorized:
			return 401
			
		case .unexpectedStatusCode(let error):
			return error.status
			
		default:
			return 0
		}
	}
}


