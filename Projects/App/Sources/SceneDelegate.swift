//
//  SceneDelegate.swift
//  SwiftyProteins
//
//  Created by Chan on 3/28/24.
//

import UIKit

import Feature
import SharedCommonUI
import Firebase
import GoogleSignIn
import AuthenticationServices
import CoreData

extension SceneDelegate: LaunchScreenViewControllerDelegate {
    func launchScreenDidFinish() {
        // 로그인 상태 확인 후 적절한 인증 절차 진행
        if let user = Auth.auth().currentUser {
            showMainView()
        } else {
            showLoginView()
        }
    }
}

// LaunchScreenViewControllerDelegate 프로토콜 정의
protocol LaunchScreenViewControllerDelegate: AnyObject {
    func launchScreenDidFinish()
}

// SceneDelegate가 LoginViewControllerDelegate 프로토콜을 준수하도록 확장
extension SceneDelegate: LoginViewControllerDelegate {
    func loginDidFinish(success: Bool, error: Error?) {
        if success {
            // 로그인 성공 후 메인 화면 표시 로직 구현
            print("로그인 성공")
            showMainView()
        } else {
            // 오류 처리 로직 구현
            print("로그인 실패: \(String(describing: error?.localizedDescription))")
        }
    }
}

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coverViewManager: CoverViewManager?
    var biometricFlow: BiometricAuthenticationFlow?
    var persistentContainer: NSPersistentContainer? {
          (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
      }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        // custom launchscreen
        let launchScreenViewController = LaunchScreenViewController()
        launchScreenViewController.delegate = self
        window?.rootViewController = launchScreenViewController
        window?.makeKeyAndVisible()
    }
    
    func showMainView() {
        // protein list view
        let initialViewController = ProteinsListViewController()
        
        window?.rootViewController = initialViewController.initialView()
        window?.makeKeyAndVisible()
        
        // 커버 뷰 관리 및 바이오메트릭 인증 플로우 초기화
        coverViewManager = CoverViewManager(window: window)
        biometricFlow = BiometricAuthenticationFlow(window: window)
        
        // 처음 앱 실행 시 커버 뷰를 추가 및 인증 시작
        coverViewManager?.addCoverView()
        
        self.authenticateUser()
    }
    
    func showLoginView() {
        // 로그인 뷰 컨트롤러 생성 및 설정
        let loginViewController = LoginViewController()
        loginViewController.delegate = self // 로그인 성공 후 콜백 처리를 위해 델리게이트 설정 필요
        window?.rootViewController = loginViewController
        window?.makeKeyAndVisible()
    }
    
    private func authenticateUser() {
        biometricFlow?.start { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    // 앱 정상 실행 Flow Feature
                    self?.coverViewManager?.removeCoverView()
                } else {
                    // 앱 꺼짐 혹은 재시도 Flow Feature
                    self?.biometricFlow?.showFailureViewController(error: error)
                }
            }
        }
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // 홈 버튼 두 번 눌러 앱이 비활성화될 때 커버 뷰 추가
        coverViewManager?.addCoverView()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // 대기 모드 진입 시 커버 뷰 추가
        coverViewManager?.addCoverView()
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // 다시 활성화될 때 인증 로직 호출
        if coverViewManager?.hasCoverView() == true {
            self.authenticateUser()
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // 다시 활성화될 때 인증 로직 호출
        if coverViewManager?.hasCoverView() == true {
            self.authenticateUser()
        }
    }
    
    //    func signInOAuthView(_ scene: UIScene) {
    //        oauthViewManager?.
    //    }
    
    private func isUserLoggedIn() -> Bool {
        guard let userContext = persistentContainer?.viewContext else {
            return false
        }
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let userEntities = try userContext.fetch(fetchRequest)
            
            if let userEntity = userEntities.first,
               let email = userEntity.email,
               let accessToken = userEntity.accessToken,
               let refreshToken = userEntity.refreshToken {
                return !email.isEmpty && !accessToken.isEmpty && !refreshToken.isEmpty
            }
        } catch {
            print("Error fetching user token: \(error)")
        }
        
        return false
    }
    
    private func saveTokensToCoreData(_ accessToken: String, _ refreshToken: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let context = persistentContainer?.viewContext else {
            return
        }
        if let userEntity = NSEntityDescription.insertNewObject(forEntityName: "UserEntity", into: context) as? UserEntity {
            userEntity.accessToken = accessToken
            userEntity.refreshToken = refreshToken

            do {
                try context.save()
                print("AccessToken and RefreshToken saved to CoreData")
            } catch {
                print("Error saving Tokens to CoreData: \(error.localizedDescription)")
            }
        } else {
            print("Failed to create UserEntity object")
        }
    }
}

// 로그인 성공 후 콜백 처리를 위한 프로토콜
protocol LoginViewControllerDelegate: AnyObject {
    func loginDidFinish(success: Bool, error: Error?)
}

class LoginViewController: UIViewController {
    var persistentContainer: NSPersistentContainer? {
          (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
      }

    // Delegate property
    weak var delegate: LoginViewControllerDelegate?
    
    // Google 로그인 버튼
    private var googleLoginButton: GIDSignInButton! // UIButton 대신 GIDSignInButton 사용
    private var AppleLoginButton : ASAuthorizationAppleIDButton!
    private var loginLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLoginLabel()
        setupGoogleLoginButton()
        setupAppleLoginButton()
    }
    
    private func setupLoginLabel() {
        let loginLabel = UILabel()
        loginLabel.text = "Swifty Proteins"
        loginLabel.textAlignment = .center
        loginLabel.font = UIFontMetrics(forTextStyle: .title1)
            .scaledFont(for: UIFont.systemFont(ofSize: 36, weight: .bold))
        loginLabel.textColor = .foregroundColor
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginLabel) // 뷰에 라벨 추가하는 부분이 빠져있어서 추가했습니다.
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height / 5)
        ])
    }

    private func setupGoogleLoginButton() {
        // Google 로그인 버튼 설정
        googleLoginButton = GIDSignInButton() // GIDSignInButton 인스턴스 생성
        googleLoginButton.colorScheme = .dark
        googleLoginButton.style = .wide // 버튼 스타일 설정, 필요에 따라 변경 가능
        googleLoginButton.addTarget(self, action: #selector(startGoogleSignIn), for: .touchUpInside)
        
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(googleLoginButton)
        
        NSLayoutConstraint.activate([
            googleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleLoginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.size.height * 0.66), // 하단 1/3 지점에 위치
            googleLoginButton.widthAnchor.constraint(equalToConstant: 280), // 버튼의 너비를 280포인트로 설정
            googleLoginButton.heightAnchor.constraint(equalToConstant: 50) // 버튼의 높이를 50포인트로 설정
        ])
    }
    
    private func setupAppleLoginButton() {
        // Apple 로그인 버튼 설정
        AppleLoginButton = ASAuthorizationAppleIDButton()
        AppleLoginButton.addTarget(self, action: #selector(startAppleSignIn), for: .touchUpInside)
        AppleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(AppleLoginButton)
        
        // Google 로그인 버튼 바로 아래에 위치하도록 NSLayoutConstraint 설정
        NSLayoutConstraint.activate([
            AppleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            AppleLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor), // Google 로그인 버튼 아래에 20포인트 간격을 두고 위치
            AppleLoginButton.widthAnchor.constraint(equalToConstant: 280), // 버튼의 너비를 280포인트로 설정
            AppleLoginButton.heightAnchor.constraint(equalToConstant: 50) // 버튼의 높이를 50포인트로 설정
        ])
    }
    
    
    @objc private func startGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        
        print("Starting Google Sign-In process")
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [weak self] user, error in
            if let error = error {
                print("Google Sign-In Error: \(error.localizedDescription)")
                self?.delegate?.loginDidFinish(success: false, error: error)
                return
            }
            
            guard let authentication = user?.authentication, let idToken = authentication.idToken else {
                print("Google Sign-In Error: Missing ID Token")
                self?.delegate?.loginDidFinish(success: false, error: error)
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if let error = error {
                    print("Firebase Sign-In Error: \(error.localizedDescription)")
                    self?.delegate?.loginDidFinish(success: false, error: error)
                    return
                }
                
                // 로그인 성공 후 처리 로직 추가
                print("Firebase Sign-In Success: \(String(describing: authResult?.user.email))")
                
                // accessToken과 refreshToken을 CoreData에 저장하는 코드
                self?.saveTokensToCoreData(_email: (authResult?.user.email)!, authentication.accessToken, authentication.refreshToken)
                
                self?.delegate?.loginDidFinish(success: true, error: nil)
            }
        }
    }
    
    @objc private func startAppleSignIn() {
    }
    
    private func saveTokensToCoreData(_email: String, _ accessToken: String, _ refreshToken: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
              let context = persistentContainer?.viewContext else {
            return
        }

            do {
                try context.save()
                print("AccessToken and RefreshToken saved to CoreData")
            } catch {
                print("Error saving Tokens to CoreData: \(error.localizedDescription)")
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }

}
