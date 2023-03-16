import Foundation

protocol TestRepository: HTTPClient {
	var session: URLSession { get }

	func getUser() async -> Result<String, RequestError>
}

// MARK: Live
struct TestRepositoryLive: TestRepository {
	var session: URLSession

	func getUser() async -> Result<String, RequestError> {
//		await sendRequest(endpoint: TestEndpoint.getUser, responseModel: String.self)
		.success("Live 유저입니다.")
	}
}

// MARK: Mock
struct TestRepositoryMock: TestRepository {
	var session: URLSession

	func getUser() async -> Result<String, RequestError> {
		.success("Mock 유저입니다.")
	}
}
