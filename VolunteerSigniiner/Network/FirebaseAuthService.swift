//
//  FirebaseAuthService.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/4/11.
//

import Foundation
import FirebaseAuth
import Firebase
import GoogleSignIn
import FirebaseDatabase
import FirebaseCore
import FirebaseFirestore



class FirebaseAuthService {
    
    private let auth = Auth.auth()
    
    private let dataBase = Database.database()
    
    private lazy var userReference = dataBase.reference(withPath: "users")
    //創建使用者
    func createUser(with email: String, with password: String, completion: @escaping ((String) -> Void)) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error as NSError?, let errorCode = AuthErrorCode.Code(rawValue: error.code) {
                switch errorCode {
                case .emailAlreadyInUse: completion("電子郵件已經註冊過了")
                case .invalidEmail:      completion("請輸入有效的電子郵件地址")
                case .weakPassword:      completion("密碼強度不足，請輸入至少6個字符的密碼")
                default:                 completion("註冊失敗，請稍後再試")
                }
                return
            }
            
            guard let uid = authResult?.user.uid else {
                return
            }
            self.userReference.queryOrdered(byChild: "email").queryEqual(toValue: email)
                .observeSingleEvent(of: .value) { snapShot, text in
                    if snapShot.exists() {
                        return
                    }
                    let name = snapShot.childSnapshot(forPath: "name").value as? String
                    let email = snapShot.childSnapshot(forPath: "email").value as? String
                    let user = User(name: name ?? "", email: email ?? "")
                    self.userReference.child(uid).setValue(user)
            }
        }
    }
    
    func userLogin(with email: String, password: String, completion: @escaping(Result<Bool,Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(true))
        }
    }
    
    func registerWithCredential(with credential: AuthCredential, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let uid = authResult?.user.uid {
                let userData = [
                    "name": authResult?.user.displayName ?? "",
                    "email": authResult?.user.email ?? ""
                ]
                Firestore.firestore().collection("users").document("uid").setData(userData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(true))
                    }
                }
            }
            
        }
    }
}
