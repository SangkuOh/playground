import Foundation

protocol Endpoint {
	var scheme: String { get }
	var host: String { get }
	var path: String { get }
	var method: RequestMethod { get }
	var header: [String: String]? { get }
	var query: [String: String]? { get }
	var body: Encodable? { get }
}

extension Endpoint {
	var scheme: String {
		"https"
	}
	
	var host: String {
		Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? ""
	}
}


