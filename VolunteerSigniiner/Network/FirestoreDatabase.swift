//
//  FirestoreDatabase.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/5/2.
//

import Foundation
import FirebaseFirestore
import FirebaseDatabase

enum RequestType {
    case serviceID, email, userName, identity,timeStamp
}

class FirestoreDatabase {
    
    static let shared = FirestoreDatabase()
    
    private let fireStoreDataBase = Firestore.firestore()
    
    private let timeCheckHelper = TimeCheckHelper()
    
    //MARK: - Methods
    func uploadScanInformation(name: String, serviceID: String, uid: String, email: String, identity: String) {
        let currentTime = timeCheckHelper.getCurrentTimeString()
        let data: [String: Any] = [
            "email": email,
            "identity": identity,
            "serviceID": serviceID,
            "timeStamp": currentTime,
            "uid": uid,
            "userName": name
        ]
        insertToFirestore(data: data)
    }
    
    //MARK: - Firebase CRUD Methods
    func insertToFirestore(data: [String: Any]) {
        fireStoreDataBase.collection("SignInData").addDocument(data: data) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func readFromFirestore() {
        fireStoreDataBase.collection("SignInData").getDocuments() { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func readCertainInfoFromFirestore(serviceID: String?,
                                      email: String?,
                                      identity: String?,
                                      timeStamp: String?,
                                      userName: String?,
                                      completion: @escaping (Result<[[String: Any]], Error>) -> Void) {
        let signInDataCollection = fireStoreDataBase.collection("SignInData")
        var query = signInDataCollection
        
        if let serviceID = serviceID {
            query.whereField("serviceID", isEqualTo: serviceID)
        }
        
        if let email = email {
            query.whereField("email", isEqualTo: email)
        }
        
        if let identity = identity {
            query.whereField("identity", isEqualTo: identity)
        }
        if let timeStamp = timeStamp {
            query.whereField("timeStamp", isEqualTo: timeStamp)
        }
        
        if let userName = userName {
            query.whereField("userName", isEqualTo: userName)
        }
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = querySnapshot else {
                let error = NSError(domain: "Error", code: -1)
                completion(.failure(error))
                return
            }
            
            var results = [[String: Any]]()
            for document in snapshot.documents {
                results.append(document.data())
            }
            completion(.success(results))
        }
    }
    
    func updateFirestore(documentId: String, data: [String: Any]) {
        let documentRef = fireStoreDataBase.collection("SignInData").document(documentId)
        documentRef.updateData(data) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
    
    func deleteFromFirestore(documentId: String) {
        let documentRef = fireStoreDataBase.collection("SignInData").document(documentId)
        documentRef.delete() { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document successfully deleted!")
            }
        }
    }
    
}
