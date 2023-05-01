//
//  SignUpViewModel.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/4/2.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import GoogleSignIn
import FirebaseAuth
import FBSDKLoginKit
 
enum VerifyState: Int, CaseIterable {
    case verify = 0, unverify
    var acountVerify: String {
        switch self {
        case .verify: return "通過驗證"
        case .unverify: return "您的帳號不完整"
        }
    }
    var passwordVerify: String {
        switch self {
        case .verify: return "通過驗證"
        case .unverify: return "密碼字數不足"
        }
    }
    
    var checkAccountAndPasswordVerify: String {
        switch self {
        case .verify: return "已填寫"
        case .unverify: return "未填寫"
        }
    }
}

enum AuthError: Error {
    case unknown
    case cancelled
}

class SignUpViewModel {
    
    var pushToController: (() -> Void)?
    
    //MARK: - UI
    let loginButtonLoginTapped = PublishSubject<Void>()
    
    let googleSignInTapped = PublishSubject<UIViewController>()
    
    let facebookSignInTapped = PublishSubject<UIViewController>()
    
    let accountInputChanged = BehaviorRelay<String>(value: "")
    
    let passwordInputChanged = BehaviorRelay<String>(value: "")
    
    private let disposeBag = DisposeBag()
    
    private let authService = FirebaseAuthService()
    
    private let facebookLoginManager = LoginManager()
    
    private var inputAccount: String = ""
    
    private var inputPassword: String = ""
    
    //MARK: - initialization
    init() {
        accountInputChanged
            .subscribe(onNext: { text in
            print("Account text:\(text)")
        })
        .disposed(by: disposeBag)
        
        passwordInputChanged
            .subscribe(onNext: { text in
                print("Password text:\(text)")
            })
            .disposed(by: disposeBag)
        
        loginButtonLoginTapped.subscribe { [weak self] in
            self?.normalSignUp()
        }
        
        googleSignInTapped.subscribe(onNext: { viewController in
            self.googleSignUp(with: viewController)
        })
        .disposed(by: disposeBag)
        
        facebookSignInTapped.subscribe(onNext: { viewController in
            self.facebookSignUp(from: viewController) { result in
                print("reault:\(result))")
            }
        })
        .disposed(by: disposeBag)
    }
    
    func normalSignUp() {
        authService.createUser(with: inputAccount, with: inputPassword) { response in
            print("response:\(response.description)")
        }
    }
    
    func facebookSignUp(from viewController: UIViewController, completion: @escaping (Result<String, Error>) -> Void) {
        facebookLoginManager.logIn(permissions: ["public_profile", "email"], from: viewController) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let token = result?.token else {
                completion(.failure(AuthError.unknown))
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            self.authService.registerWithCredential(with: credential) { result in
                switch result {
                case .success(let result): completion(.success("result:\(result.description)"))
                case .failure(let error): completion(.failure(error))
                }
            }
        }
    }

    
    func googleSignUp(with viewController: UIViewController) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
        //完成之後填入事件流
        if let currentUser = GIDSignIn.sharedInstance.currentUser {
            let email = currentUser.profile?.email ?? ""
            let password = currentUser.idToken?.tokenString ?? ""
            authService.createUser(with: email, with: password) { response in
                if response == "電子郵件已經註冊過了" {
                    self.pushToController?()
                    //還要跳一個提示：請直接登入的Alert
                }
            }
        }
    }
    
    func googleSignOut() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    //MARK: - Check Account and Password
    func checkBothAcountAndPassword(with account: String, with password: String) -> String {
        if account == "" && password == "" {
            return "帳號與密碼皆未填寫"
        } else if account == "" {
            return "帳號未填寫"
        } else if password == "" {
            return "密碼未填寫"
        } else {
            return "完成填寫"
        }
    }
    
    func checkAcount(with text: String) -> VerifyState {
        let standardAcount = "example@mail.com"
        let seperatedString = standardAcount.components(separatedBy: ".")
        let isValid = seperatedString.allSatisfy { $0.contains("mail") && $0.contains("com") }
        let inputSeparatedStrings = text.components(separatedBy: ".")
        let isInputValid = inputSeparatedStrings.allSatisfy { $0.contains("mail") && $0.contains("com") }
        return isInputValid ? VerifyState.verify : VerifyState.unverify
    }
    
    func checkPassword(with text: String) -> VerifyState {
        return text.count < 10 ? VerifyState.unverify : VerifyState.verify
    }
}
    

         
