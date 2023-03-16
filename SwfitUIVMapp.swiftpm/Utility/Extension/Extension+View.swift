//
//  File.swift
//  
//
//  Created by sangku on 2023/03/16.
//

import SwiftUI

// MARK: Debounce
extension View {
	public func onChange<Value>(
		of value: Value,
		debounceTime: TimeInterval,
		perform action: @escaping (_ newValue: Value) -> Void
	) -> some View where Value: Equatable {
		self.modifier(DebouncedChangeViewModifier(trigger: value, debounceTime: debounceTime, action: action))
	}
}

private struct DebouncedChangeViewModifier<Value>: ViewModifier where Value: Equatable {
	let trigger: Value
	let debounceTime: TimeInterval
	let action: (Value) -> Void

	@State private var debouncedTask: Task<Void, Never>?

	func body(content: Content) -> some View {
		content.onChange(of: trigger) { value in
			debouncedTask?.cancel()
			debouncedTask = Task.delayed(seconds: debounceTime) { @MainActor in
				action(value)
			}
		}
	}
}

// MARK: redacted
extension View {
	@ViewBuilder
	func redacted(if condition: @autoclosure () -> Bool) -> some View {
		redacted(reason: condition() ? .placeholder : [])
	}
}

