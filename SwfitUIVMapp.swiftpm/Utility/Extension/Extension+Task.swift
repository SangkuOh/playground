import Foundation

extension Task {
	@discardableResult
	public static func delayed(
		seconds: TimeInterval,
		operation: @escaping @Sendable () async -> Void
	) -> Self where Success == Void, Failure == Never {
		Self {
			do {
				try await Task<Never, Never>.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
				await operation()
			} catch {}
		}
	}
}


