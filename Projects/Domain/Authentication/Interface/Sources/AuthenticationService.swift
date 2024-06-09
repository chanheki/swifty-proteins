//
//  AuthenticationService.swift
//  DomainAuthentication
//
//  Created by Chan on 6/9/24.
//

import UIKit

public protocol AuthenticationService: AnyObject {
    func saveTokensToCoreData(_ email: String, _ accessToken: String, _ refreshToken: String)
    func isUserLoggedIn() -> Bool
    func appleSignIn(presentingViewController: UIViewController, completion: @escaping (Bool, Error?) -> Void)
}
