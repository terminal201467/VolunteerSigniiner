//
//  LoginViewModel.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/4/2.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import GoogleSignIn
 
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


class LoginViewModel {
    
    //MARK: - UI
    let loginButtonLoginTapped = PublishSubject<Void>()
    
    let googleSignInTapped = PublishSubject<Void>()
    
    let facebookSignInTapped = PublishSubject<Void>()
    
    let accountInputChanged = BehaviorRelay<String>(value: "")
    
    let passwordInputChanged = BehaviorRelay<String>(value: "")
    
    private let disposeBag = DisposeBag()
    
    private let authService = FirebaseAuthService()
    
    private var inputAccount: String = ""
    
    private var inputPassword: String = ""
    
    //MARK: - initialization
    init() {
        accountInputChanged
            .subscribe(onNext: { text in
            print("text:\(text)")
        })
        .disposed(by: disposeBag)
        
        passwordInputChanged
            .subscribe(onNext: { text in
                print("text:\(text)")
            })
            .disposed(by: disposeBag)
        
        loginButtonLoginTapped.subscribe { [weak self] in
            guard let self = self else { return }
            self.authService.register(with: self.inputAccount, password: self.inputPassword) { (result) in
                switch result {
                case .success:
                    print("\(self.checkBothAcountAndPassword(with: self.inputAccount, with: self.inputPassword))")
                    print("Login Successful")
                case .failure(let error):
                    print("Login Error:\(error)")
                }
            }
        }
        
        googleSignInTapped.subscribe(onNext: { [weak self] in
            self?.googleSignIn()
        })
        .disposed(by: disposeBag)
        
        facebookSignInTapped.subscribe(onNext: { [weak self] in
            self?.facebookSignIn()
        })
        .disposed(by: disposeBag)
    }
    
    func facebookSignIn() {
        
    }
    
    func googleSignIn() {
        let viewController = GoogleSignInViewController()
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
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
    

         
