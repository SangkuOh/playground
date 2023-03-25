// MARK: Placeholder
extension String {
    static func placeholder(length: Int) -> String {
        String(Array(repeating: "X", count: length))
    }
}

