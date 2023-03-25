enum Repository {
    case live
    case mock
}

extension Repository {
    var test: TestRepository {
        switch self {
        case .live:
            return TestRepositoryLive
                .init(session: .repositorySession)
            
        case .mock:
            return  TestRepositoryMock
                .init(session: .repositorySession)
        }
    }
}
