// This is for Tuist

public protocol AuthenticationInterface {
    func authenticate(completion: @escaping (Bool, Error?) -> Void)
}
