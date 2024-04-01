public protocol BiometricAuthenticationServiceProtocol {
    func authenticate(completion: @escaping (Bool, Error?) -> Void)
}
