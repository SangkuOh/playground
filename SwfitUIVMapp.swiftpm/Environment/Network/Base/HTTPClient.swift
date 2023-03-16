import Foundation

protocol HTTPClient {
	var session: URLSession { get }

	typealias Parameters = [String: String]

	func sendRequest<T: Decodable>(
		endpoint: Endpoint,
		responseModel: T.Type
	) async -> Result<T, RequestError>

	func sendMultipartRequest<T: Decodable>(
		endpoint: Endpoint,
		fieldName: String,
		datas: [Data]?,
		responseModel: T.Type
	) async -> Result<T, RequestError>
}

// MARK: Request
extension HTTPClient {
	func sendRequest<T: Decodable>(
		endpoint: Endpoint,
		responseModel: T.Type
	) async -> Result<T, RequestError> {
		var urlComponents = URLComponents()
		urlComponents.scheme = endpoint.scheme
		urlComponents.host = endpoint.host
		urlComponents.path = endpoint.path

		if let query = endpoint.query {
			urlComponents.queryItems = query.map {
				.init(
					name: $0,
					value: $1.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
				)
			}
		}

		guard let url = urlComponents.url else {
			return .failure(.invalidURL)
		}

		var request = URLRequest(url: url)
		request.httpMethod = endpoint.method.rawValue
		request.allHTTPHeaderFields = endpoint.header

		if let body = endpoint.body {
			let jsonData = request.encoded(encodable: body)
			request.httpBody = jsonData
		}

		NetworkLogger.log(request: request)

		do {
			let (data, response) = try await session.data(for: request, delegate: nil)
			NetworkLogger.log(response: response as? HTTPURLResponse, data: data)
			guard let response = response as? HTTPURLResponse else {
				return .failure(.noResponse)
			}
			switch response.statusCode {
			case 200...203:
				do {
					let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
					return .success(decodedResponse)
				} catch {
					return .failure(.decode(error))
				}

			case 204:
				guard let emptyResponse: T = EmptyResponse() as? T else {
					return .failure(.unknown("204 has body"))
				}
				return .success(emptyResponse)

			case 401:
				return .failure(.unauthorized)

			default:
				let decodedResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
				return .failure(.unexpectedStatusCode(decodedResponse))
			}
		} catch {
			return .failure(.unknown(error.localizedDescription))
		}
	}

	func sendMultipartRequest<T: Decodable>(
		endpoint: Endpoint,
		fieldName: String,
		datas: [Data]?,
		responseModel: T.Type
	) async -> Result<T, RequestError> {
		var urlComponents = URLComponents()
		urlComponents.scheme = endpoint.scheme
		urlComponents.host = endpoint.host
		urlComponents.path = endpoint.path

		guard let url = urlComponents.url else {
			return .failure(.invalidURL)
		}

		var request = URLRequest(
			url: url,
			cachePolicy: .reloadIgnoringLocalCacheData,
			timeoutInterval: 60
		)
		request.httpMethod = endpoint.method.rawValue

		let boundary = "Boundary-\(UUID().uuidString)"
		request.setValue(
			"multipart/form-data; boundary=\(boundary)",
			forHTTPHeaderField: "Content-Type"
		)
		request.setValue(
			"Bearer Token.access.tokenString",
			forHTTPHeaderField: "Authorization"
		)

		var httpBody = Data()

		if let body = endpoint.body as? Parameters {
			for (key, value) in body {
				httpBody.appendString(
					convertFormField(
						named: key,
						value: value,
						using: boundary
					)
				)
			}
		}
		if let datas {
			for (index, data) in datas.enumerated() {
				httpBody.append(
					convertFileData(
						fieldName: fieldName,
						fileName: "\(index)_photo.png",
						mimeType: "multipart/form-data",
						fileData: data,
						using: boundary
					)
				)
			}
		}

		httpBody.appendString("--\(boundary)--")
		request.httpBody = httpBody

		NetworkLogger.log(request: request)

		do {
			let (data, response) = try await session.data(for: request, delegate: nil)
			NetworkLogger.log(response: response as? HTTPURLResponse, data: data)
			guard let response = response as? HTTPURLResponse else {
				return .failure(.noResponse)
			}
			switch response.statusCode {
			case 200...299:
				do {
					let decodedResponse = try JSONDecoder().decode(responseModel, from: data)
					return .success(decodedResponse)
				} catch {
					return .failure(.decode(error))
				}

			case 401:
				return .failure(.unauthorized)

			default:
				let decodedResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
				return .failure(.unexpectedStatusCode(decodedResponse))
			}
		} catch {
			return .failure(.unknown(error.localizedDescription))
		}
	}
}

// MARK: Private
extension HTTPClient {
	private func convertFormField(
		named name: String,
		value: String,
		using boundary: String
	) -> String {
		var fieldString = "--\(boundary)\r\n"
		fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
		fieldString += "\r\n"
		fieldString += "\(value)\r\n"

		return fieldString
	}

	private func convertFileData(
		fieldName: String,
		fileName: String,
		mimeType: String,
		fileData: Data,
		using boundary: String
	) -> Data {
		var data = Data()
		data.appendString("--\(boundary)\r\n")
		data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
		data.appendString("Content-Type: \(mimeType)\r\n\r\n")
		data.append(fileData)
		data.appendString("\r\n")

		return data
	}
}


