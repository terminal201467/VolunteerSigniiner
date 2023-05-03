//
//  TimeCheckHelper.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/5/3.
//

import Foundation

enum ServiceSignInTimeType: Int, CaseIterable {
    case morningInAndOut = 0, morningInAndAfternoonOut, afternoonInAndOut
    var timePeriod: String {
        switch self {
        case .morningInAndOut: return ""
        case .morningInAndAfternoonOut: return ""
        case .afternoonInAndOut: return ""
        }
    }
}

class TimeCheckHelper {
    
    //先檢查是不是已經有掃描記錄了，如果在3小時以內已經掃描過了
    //就跳通知說：某服務的UID已經掃描過了喔
    //那我這邊的UserDefault可能就要記得某個UID暫存的時間點
    private let timeCheckDefults = UserDefaults(suiteName: "timeCheck")
    
    //如果是同一個UID在不同時段要用，要怎麼辨別它是離開服務？
    
    //下午12:00之前只能掃一次
    
    //下午12:00點之前如果掃第二次，如果是有必須要離開的話，怎麼辦？
    
    //下午12:00之後只能掃一次
    
    //那如果志工是下午12:00之後才進來，要怎麼辦？，但下午12:00之後就必須走，要怎麼辦？
    
    //
    
    func getCurrentTime() -> String{
        let timeStamp = Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    func checkIn(withTime: String) {
        
    }
    
    func checkout(withTime: String) {
        
    }
    
    
    func checkRepeatLogin(withTime: String) -> Bool {
        
        
        
        return true
    }
    
}
