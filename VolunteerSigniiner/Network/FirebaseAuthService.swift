//
//  FirebaseAuthService.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/4/11.
//

import Foundation
import FirebaseAuth
import Firebase


class FirebaseAuthService {
    
    func register(with email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func login(withEmail email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
}
