//
//  File.swift
//  
//
//  Created by sangku on 2023/03/16.
//

protocol TestService {
	var repository: Repository { get }

	func getUser() async -> Result<String, RequestError>
}

struct TestServiceValue: TestService {
	var repository: Repository

	func getUser() async -> Result<String, RequestError> {
		await repository.test.getUser()
	}
}
