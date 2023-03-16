import SwiftUI

struct ContentView: View {
	@EnvironmentObject var store: Store
	@Environment(\.testService) var testService

	@State var name: String = ""
	var body: some View {
		NavigationStack {
			VStack {
				Image(systemName: "apple.logo")
					.imageScale(.large)
					.foregroundColor(.accentColor)
				Text("Hello, world!")
			}
			.navigationTitle("hello! \(name)")
		}
		.task {
			await onAppear()
		}
	}
}

// MARK: Action
extension ContentView {
	func onAppear() async {
		await getUser()
	}
}

// MARK: API
extension ContentView {
	func getUser() async {
		guard !store.isLoading else {
			return
		}
		store.isLoading.toggle()
		let result = await testService.getUser()
		store.isLoading.toggle()

		switch result {
		case .success(let name):
			self.name = name

		case .failure(let failure):
			store.openAlert(failure)
		}
	}
}
