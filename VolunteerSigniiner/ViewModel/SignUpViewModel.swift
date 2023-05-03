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

enum AuthError: Error {
    case unknown
    case cancelled
}

class SignUpViewModel {
    
    var pushToController: (() -> Void)?
    
    //MARK: - UI
    let loginButtonLoginTapped = PublishSubject<Void>()
    
    let accountInputChanged = BehaviorRelay<String>(value: "")
    
    let passwordInputChanged = BehaviorRelay<String>(value: "")
    
    private let disposeBag = DisposeBag()
    
    private let authService = FirebaseAuthService()
    
    private let facebookLoginManager = LoginManager()
    
    private var inputAccount: String = ""
    
    private var inputPassword: String = ""
    
    private let accountCheckHelper = AccountCheckHelper()
    
    //MARK: - initialization
    init() {
        accountInputChanged
            .subscribe(onNext: { text in
                self.inputAccount = text
        })
        .disposed(by: disposeBag)
        
        passwordInputChanged
            .subscribe(onNext: { text in
                self.inputPassword = text
            })
            .disposed(by: disposeBag)
        
        loginButtonLoginTapped
            .subscribe(onNext: {
                self.normalSignUp(completion: { message in
                    print("message:\(message)")
                })
            })
            .disposed(by: disposeBag)
    }
    
    private func normalSignUp(completion: @escaping (String) -> (Void)) {
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
                authService.createUser(with: inputAccount, with: inputPassword) { response in
                    print("authService response:\(response.description)")
                    //如果電子郵件已經註冊過了，那就跳出Alert去提示，然後確定之後就跳回登入頁面去執行正規登入
                    completion(fillState.text)
                }
            }
        }
    }
}
    

         
