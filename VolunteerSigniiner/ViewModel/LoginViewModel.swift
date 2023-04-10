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
    
    let thirdPartyButtonLoginTapped = PublishSubject<Void>()
    
    let accountInputChanged = BehaviorRelay<String>(value: "")
    
    let passwordInputChanged = BehaviorRelay<String>(value: "")
    
    private let disposeBag = DisposeBag()
    
    //MARK: SignUp
    func signUp(acount: String,password: String) {
        
    }
    
    func thirdPartyLogin() {
        
    }
    
    func normalLogin() {
        
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
    

         
