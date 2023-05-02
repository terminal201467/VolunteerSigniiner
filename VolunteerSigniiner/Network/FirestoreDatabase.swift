//
//  FirestoreDatabase.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/5/2.
//

import Foundation
import FirebaseFirestore
import FirebaseDatabase

class FirestoreDatabase {
    
    static let shared = FirestoreDatabase()
    
    private let fireStoreDataBase = Firestore.firestore()
    
    func uploadScanInformation(name: String, uid: String, email: String, identity: String) {
        let timeStamp = Date().timeIntervalSince1970.description
        var data: [String: Any] = [
            "email": email,
            "identify": identity,
            "punchInID": uid,
            "timeStamp": timeStamp,
            "userName": name
        ]
        fireStoreDataBase.collection("SignInData").addDocument(data: data) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    //1.上傳使用者的基本資料
    func uploadUserBasicData() {
        
    }
    
    //2.上傳使用者今天在據點參與活動的記錄
    // 身份別
    //
    func uploadAttendData() {
        
    }
    
    //3.
    func upload() {
        
    }
}
