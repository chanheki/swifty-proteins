//
//  GoogleOAuthConfigure.swift
//  CoreAuthentication
//
//  Created by 민영재 on 6/1/24.
//

import FirebaseCore
import GoogleSignIn

public final class GoogleOAuthManager {
    public static let shared = GoogleOAuthManager()
    init() {}
    
    public func firebaseConfig() {
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        let options = FirebaseOptions(contentsOfFile: filePath)
        FirebaseApp.configure(options: options!)
    }
    
    public func googleOAuthConfig(url: URL) -> Bool {
        var handled: Bool

          handled = GIDSignIn.sharedInstance.handle(url)
          if handled {
            return true
          }

          return false
    }
}
