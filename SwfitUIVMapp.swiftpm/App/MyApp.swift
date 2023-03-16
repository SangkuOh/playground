import SwiftUI

@main
struct MyApp: App {
	@StateObject var store: Store = .init()

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environmentObject(store)
		}
	}
}
