import SwiftUI

final class Store: ObservableObject {
	// MARK: App
	@Published var appStatus: AppStatus = .splash

	// MARK: Progress
	@Published var isLoading: Bool = false

	// MARK: Error
	@Published var errorMessage: String = ""
	@Published var isError: Bool = false
}

extension Store {
	func openAlert(_ error: RequestError) {
		errorMessage = error.customMessage
		isError.toggle()
	}
}
