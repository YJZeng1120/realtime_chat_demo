enum AuthError: Error {
    case emailAlreadyInUse
    case invalidEmail
    case wrongPassword
    case tooManyRequests
    case networkError
    case unknownError

    var errorDescription: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email address is already in use."
        case .invalidEmail:
            return "Invalid email address.\nPlease enter a valid email address."
        case .wrongPassword:
            return "Your email address or password is incorrect. Please check again."
        case .tooManyRequests:
            return "Too many login attempts. Please try again later."
        case .networkError:
            return "Network error. Please check your internet connection."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
