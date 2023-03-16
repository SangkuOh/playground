//
//  File.swift
//  
//
//  Created by sangku on 2023/03/16.
//

import SwiftUI

struct TestServiceKey: EnvironmentKey {
	static let defaultValue: TestServiceValue = .init(repository: isPreview ? .mock : .live)
}

extension EnvironmentValues {
	var testService: TestServiceValue {
		get { self[TestServiceKey.self] }
		set { self[TestServiceKey.self] = newValue }
	}
}

