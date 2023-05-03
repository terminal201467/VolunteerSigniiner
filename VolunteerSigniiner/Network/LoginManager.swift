//
//  LoginManager.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/5/2.
//

import Foundation

enum UserKeys: Int, CaseIterable{
    case name = 0, email, gender, identity, isLoggedKey
    var keyString: String {
        switch self {
        case .name: return "nameKey"
        case .email: return "emailKey"
        case .gender: return "genderKey"
        case .identity: return "identityKey"
        case .isLoggedKey: return "isLoggedKey"
        }
    }
}

class LoginManager {
    
    static let shared = LoginManager()
    //UserDefault
    private let userDefault = UserDefaults(suiteName: "userLogin")
    
    var isLoggedIn: Bool = false {
        didSet {
            userDefault?.set(isLoggedIn, forKey: UserKeys.isLoggedKey.keyString)
        }
    }

    init() {
        let isLogged = UserDefaults.standard.bool(forKey: UserKeys.isLoggedKey.keyString)
        if isLogged {
            self.isLoggedIn = isLogged
        }
    }
    
    //登入後會儲存使用者資料
    func registerSaveUser(userName: String?, userEmail: String?, userGender: String?, userIdentity: String?, completion: @escaping (String) -> Void) {
        guard let name = userName else {
            completion("未提供使用者姓名")
            return
        }
        guard let email = userEmail else {
            completion("未提供使用者Email")
            return
        }
        guard let gender = userGender else {
            completion("未提供使用者性別")
            return
        }
        guard let identity = userIdentity else {
            completion("未提供使用者身份")
            return
        }
        userDefault?.set(name, forKey: UserKeys.name.keyString)
        userDefault?.set(email, forKey: UserKeys.email.keyString)
        userDefault?.set(gender, forKey: UserKeys.gender.keyString)
        userDefault?.set(identity, forKey: UserKeys.identity.keyString)
        completion("完成註冊資料提供")
        userDefault?.set(true, forKey: UserKeys.isLoggedKey.keyString)
    }
    
    func storeUserIdentity(with identity: String?, completion: @escaping (String) -> Void) {
        if let identity = identity {
            if identity == "管理者" {
                userDefault?.setValue(identity, forKey: UserKeys.identity.keyString)
                completion("完成提供身份資訊")
            } else if identity == "志工" {
                userDefault?.setValue(identity, forKey: UserKeys.identity.keyString)
                completion("完成提供身份資訊")
            }
        }
        completion("未提供")
    }
    
    
    
}
