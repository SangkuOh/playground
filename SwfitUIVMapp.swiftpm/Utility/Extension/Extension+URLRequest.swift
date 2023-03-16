import Foundation

internal extension URLRequest {
	mutating func encoded(
		encodable: Encodable,
		encoder: JSONEncoder = JSONEncoder()
	) -> Data? {
		try? encoder.encode(encodable)
	}
}


