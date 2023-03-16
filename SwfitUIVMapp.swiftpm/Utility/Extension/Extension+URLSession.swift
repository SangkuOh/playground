import Foundation

extension URLSession {
	static var repositorySession: URLSession = .init(configuration: sessionConfiguration)
	
	static var sessionConfiguration: URLSessionConfiguration {
		let configuration = URLSessionConfiguration.default
		configuration.timeoutIntervalForRequest = 60
		configuration.timeoutIntervalForResource = 120
		configuration.waitsForConnectivity = true
		configuration.httpMaximumConnectionsPerHost = 5
		configuration.requestCachePolicy = .returnCacheDataElseLoad
		configuration.urlCache = .shared
		return configuration
	}
}
