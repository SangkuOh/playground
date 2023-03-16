import Foundation

enum Token: String {
	case access = "accessToken"
	case refresh = "refreshToken"
}

extension Token {
	var tokenString: String {
		UserDefaults.standard.string(forKey: self.rawValue) ?? ""
	}
}

