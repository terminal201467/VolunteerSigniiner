//
//  LoginViewModel.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/4/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import GoogleSignIn
import FirebaseAuth
import FBSDKLoginKit

class LoginViewModel {
    
    //MARK: - UI
    let loginButtonLoginTapped = PublishSubject<Void>()
    
    let googleSignInTapped = PublishSubject<UIViewController>()
    
    let facebookSignInTapped = PublishSubject<String>()
    
    let accountInputChanged = BehaviorRelay<String>(value: "")
    
    let passwordInputChanged = BehaviorRelay<String>(value: "")
    
    private let disposeBag = DisposeBag()
    
    private let authService = FirebaseAuthService()
    
    private let accountCheckHelper = AccountCheckHelper()
    
    private let facebookLoginManager = LoginManager()
    
    private var inputAccount: String = ""
    
    private var inputPassword: String = ""
    
    //MARK: -LoginControl
    
    var loginResponse: ((String) -> Void)?
    
    //MARK: -Initialization
    
    init() {
        accountInputChanged
            .subscribe(onNext: { text in
            print("Account text:\(text)")
            self.inputAccount = text
        })
        .disposed(by: disposeBag)
        
        passwordInputChanged
            .subscribe(onNext: { text in
                print("Password text:\(text)")
                self.inputPassword = text
            })
            .disposed(by: disposeBag)
        
        loginButtonLoginTapped.subscribe(onNext: { [weak self] in
            self?.normalLogin(completion: { loginResponse in
                print("loginResponse:\(loginResponse.description)")
                self?.loginResponse?(loginResponse)
            })
        })
        
        googleSignInTapped.subscribe(onNext: { viewController in
            self.googleLogin(viewController: viewController) { loginResponse in
                print("loginResponse:\(loginResponse.description)")
                self.loginResponse?(loginResponse.description)
            }
        })
        .disposed(by: disposeBag)
        
        facebookSignInTapped.subscribe(onNext: { accessToken in
            self.facebookSignIn(with: accessToken) { result in
                switch result {
                case .failure(let error):
                    print("error:\(error.localizedDescription)")
                case .success(let result):
                    self.loginResponse?("\(result)")
                }
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func normalLogin(completion: @escaping (String) -> (Void)) {
        let fillState = accountCheckHelper.checkBothAcountAndPassword(with: inputAccount, with: inputPassword)
        switch fillState {
        case .acountUnfill:
            print(fillState.text)
            completion(fillState.text)
        case .passwordUnfill:
            print(fillState.text)
            completion(fillState.text)
        case .bothUnfill:
            print(fillState.text)
            completion(fillState.text)
        case .fillComplete:
            print(fillState.text)
            if accountCheckHelper.checkAccount(with: inputAccount) == .unverify {
                print(accountCheckHelper.checkAccount(with: inputAccount).acountVerify)
            } else if accountCheckHelper.checkPassword(with: inputPassword) == .unverify {
                print(accountCheckHelper.checkPassword(with: inputPassword).passwordVerify)
            } else {
                authService.userLogin(with: self.inputAccount, password: self.inputPassword) { result in
                    switch result {
                    case .failure(let error):
                        print("error:\(error.localizedDescription)")
                        completion("登入失敗")
                    case .success(let message):
                        print("Login succecss:\(message)")
                        completion("登入成功")
                    }
                }
            }
        }
    }
    
    //google登入
    private func googleLogin(viewController: UIViewController, completion: @escaping ((String) -> Void)) {
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { user, error in
            if let error = error {
                print("Google 登入失敗:\(error.localizedDescription)")
                completion("登入失敗")
            }
            
            guard let idToken = user?.user.idToken?.tokenString else {
                print("無法獲取idToken")
                return
            }
            
            guard let accessToken = user?.user.accessToken.tokenString else {
                print("無法獲取accessToken")
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase登入失敗：\(error.localizedDescription)")
                    completion("登入失敗")
                    return
                }
                print("登入成功")
                completion("登入成功")
            }
        }
    }
    
    //facebook登入
    func facebookSignIn(with accessToken: String, completion: @escaping (Result<String, Error>) -> Void) {
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
            self.authService.registerWithCredential(with: credential) { result in
                switch result {
                case .success(let result): completion(.success("\(result.description)"))
                case .failure(let error): completion(.failure(error))
            }
        }
    }
}
