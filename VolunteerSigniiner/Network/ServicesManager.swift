//
//  ServicesManager.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/5/1.
//

import Foundation

class ServicesManager {
    
    //這裡會分成三者： 1.服務項目UID 2.管理者UID 3.開發者UID
    //農場服務QRCode
    //服務時間：3、5、6 --> 12:00-17:30
    //-----------------------------------------------------------------------------------
    static let farmServiceLoginID: String = "kNDaKlA0nHn5ABdRwRznJIzF1N25"
    
    //鵬程據點QRCode
    ///服務時間：1-6 --> 8:30-17:30
    static let pengChengServiceLoginID: String = "FGJfo00MzTog3PHk3dQztWgqbJb2"
    
    //惠來老人據點QRCode
    ///服務時間：1-6 --> 8:30-17:30
    static let huiLaiElderSeerviceLoginID: String = "RfV7Drhd45OcJEn7vU8yIuV7myl2"
    
    //惠來身障據點QRCode
    ///服務時間：3、5 --> 8:30-12:00
    static let huiLaiDisablePeopleServiceLoginID: String = "oeEL7VpzeVD6uN7aIvE8uW7eUAb2"
    
    //募款產品QRcode
    ///服務時間：1-5 --> 8:30-17:30
    static let fundraisingServiceLoginID: String = "LrJ6xfoNgtzdsqCnT2Qsjy7PmmJ2"
    
    //-------------------------------------------------------------------------------------
    ///管理者UID基本上就是提供了這個QRCode，自己就是服務就是了
    ///但基本上管理者可以選擇上面服務類型的QRCode去給使用者刷，所以到時候就是管理者可以自己產生。
    
    //管理者QRCode
    static let managerOneID: String = "HbHezKjC24g0fb0p5H02tqwAatL2"
    static let managerTwoID: String = "2iPGxYZx0zxtBrr4vkB4E8w4fdD2"
    
    //開發者QRCode
    static let developerID: String = "hZIOe33HTuCA7p0z0oiWw7VUvNr2"
    
}
