//
//  QRCodeService.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/4/28.
//

import Foundation
import UIKit
import AVFoundation

class QRCodeService {
    
    private let filter = CIFilter(name: "CIQRCodeGenerator")
    
    private let firebaseAuthService = FirebaseAuthService()
    
    func createQRCode(uid: String) -> UIImage? {
        let qrcode = firebaseAuthService.getCurrentUser()?.uid
        let data = qrcode?.data(using: String.Encoding.isoLatin1)
        filter?.setDefaults()
        filter?.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        if let output = filter?.outputImage?.transformed(by: transform) {
            let qrcodeImage = UIImage(ciImage: output)
            return qrcodeImage
        }
        return nil
    }
    
}
