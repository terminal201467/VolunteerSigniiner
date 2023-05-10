//
//  VolunteerViewModel.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/5/8.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import RxSwift
import RxCocoa



class VolunteerViewModel {
    
    private let serviceManeger = ServicesManager()
    
    private let firebaseAuthAervice = FirebaseAuthService()
    
    private let firebaseStore = FirestoreDatabase()
    
    private let timeCheckHelper = TimeCheckHelper()
    
    private var storeStartInfo: [User] = []
    
    private var storeFinishInfo: [User] = []
    
    var isBeginService: Bool = false
    //使用者資訊
    func getUserName() -> String {
        self.firebaseAuthAervice.getCurrentUser()?.displayName ?? "使用者"
    }
    
    //MARK: -送出記錄服務
    func sendOutFirstRecord(serviceID: String) {
        let name = self.firebaseAuthAervice.getCurrentUser()?.displayName ?? "使用者"
        let uid = self.firebaseAuthAervice.getCurrentUser()?.uid ?? "未知的uid"
        let email = self.firebaseAuthAervice.getCurrentUser()?.email ?? ""
        firebaseStore.uploadScanInformation(name: name, serviceID: serviceID, uid: uid, email: email, identity: "志工")
    }
    
    //MARK: - 記錄結束服務的相關資訊
    func storeLastServiceInfo(serviceID: String) {
        let name = self.firebaseAuthAervice.getCurrentUser()?.displayName ?? "使用者"
        let uid = self.firebaseAuthAervice.getCurrentUser()?.uid ?? "未知的uid"
        let email = self.firebaseAuthAervice.getCurrentUser()?.email ?? ""
        storeFinishInfo.append(User(name: name, email: email, identity: "志工", timeStamp: timeCheckHelper.getCurrentTimeString(), serviceID: serviceID, uid: uid))
    }
    
    //MARK: - 存入第一筆開始服務紀錄
    func storeStartServiceInfo(serviceID: String) {
        let name = self.firebaseAuthAervice.getCurrentUser()?.displayName ?? "使用者"
        let uid = self.firebaseAuthAervice.getCurrentUser()?.uid ?? "未知的uid"
        let email = self.firebaseAuthAervice.getCurrentUser()?.email ?? ""
        let userInfo = User(name: name, email: email, identity: "志工", timeStamp: timeCheckHelper.getCurrentTimeString(), serviceID: serviceID, uid: uid)
        storeStartInfo.append(userInfo)
        isBeginService = true
    }
    
    //MARK: - 拿第一筆結束服務紀錄
    func getFirstServiceInfo() -> User? {
        if storeStartInfo.isEmpty {
            print("尚無開始資料")
            return nil
        } else {
            return storeStartInfo.first ?? User(name: "未知的使用者", email: "無資料", identity: "無資料", timeStamp: "無資料", serviceID: "無資料", uid: "無資料")
        }
    }
    
    //MARK: - 拿最後一筆結束服務紀錄
    func getLastServiceInfo() -> User? {
        if storeFinishInfo.isEmpty {
            print("尚無結束資料")
            return nil
        } else {
            return storeFinishInfo.last ?? User(name: "未知的使用者", email: "無資料", identity: "無資料", timeStamp: "無資料", serviceID: "無資料", uid: "無資料")
        }
    }
    
    func sendOutLastServiceRecord() {
        let lastServiceRecord = getLastServiceInfo()
        firebaseStore.uploadScanInformation(name: lastServiceRecord?.name ?? "", serviceID: lastServiceRecord?.serviceID ?? "", uid: lastServiceRecord?.uid ?? "", email: lastServiceRecord?.email ?? "", identity: "志工")
        isBeginService = false
    }
    
    //MARK: -回覆初始狀態
    func restartService() {
        isBeginService = false
        storeFinishInfo.removeAll()
    }
    
}
