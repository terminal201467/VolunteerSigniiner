//
//  TimeCheckHelper.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/5/3.
//

import Foundation

class TimeCheckHelper {
    
    //先檢查是不是已經有掃描記錄了，如果在3小時以內已經掃描過了
    //就跳通知說：某服務的UID已經掃描過了喔
    //那我這邊的UserDefault可能就要記得某個UID暫存的時間點
    private let timeCheckDefaults = UserDefaults(suiteName: "timeCheck")
    
    func getCurrentTimeString() -> String {
        let timeStamp = Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    func getCurrentTime() -> Date {
        let timeStamp = Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: timeStamp)
        return date
    }
    
    func transferTimeStringToDate(by timeString: String) -> Date? {
        let dateFormatter = DateFormatter()
        if let date = dateFormatter.date(from: timeString) {
            return date
        } else {
            return nil
        }
    }
    
//    func checkInSavedTime(serviceID: String, UID: String, completion: @escaping (Result<String, Error>) -> Void ) {
//        //get sericeID在今天的時間範疇下，某UID有沒有兩筆資料
//        var certainServiceInfo: [User] = []
//        firestore.readCertainInfoFromFirestore(serviceID: serviceID,
//                                               email: nil,
//                                               identity: nil,
//                                               timeStamp: nil,
//                                               userName: nil) { result in
//            switch result {
//            case .success(let success):
//                for data in success {
//                    if let userName = data["userName"] as? String,
//                       let email = data["email"] as? String,
//                       let serviceID = data["serviceID"] as? String,
//                       let timeStamp = data["timeStamp"] as? String,
//                       let identity = data["identity"] as? String,
//                       let uid = data["uid"] as? String {
//                        if uid == UID {
//                            let uidCertainUser = User(name: userName, email: email, identity: identity, timeStamp: timeStamp, serviceID: serviceID, uid: uid)
//                            certainServiceInfo.append(uidCertainUser)
//                        }
//                    }
//                }
//                if certainServiceInfo.count == 2 {
//                    //如果已經有兩筆
//                        //刪除Firestore上最後時間戳記的那筆
//                    
//                    certainServiceInfo.removeLast()
//                        //上傳最後時間戳記的那筆
//                } else {
//                    //沒有兩筆資料
//                        //上傳最新的時間戳記的那筆
//                }
//            case .failure(let failure):
//                print(failure.localizedDescription)
//            }
//        }
//        
//        //一天之中，一個serviceID、UID只能有兩筆時間戳記，且最後一筆時間戳記必須是最晚上傳的那筆
//        
//        //先把debounce放一邊，讓上傳者不要打爆Firebase之後再實現
//    }
}
