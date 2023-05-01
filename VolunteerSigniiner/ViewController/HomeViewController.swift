//
//  HomeViewController.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/4/28.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var helloAndNameLabel: UILabel!
    
    @IBOutlet var qrCodeImage: UIImageView!
    
    @IBOutlet var reloadButton: UIButton!
    
    @IBOutlet var scanHintLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //這個頁面，我打算放使用者的名字、還有身份QRcode
    
    private func setName() {
        
    }
    
    private func setQRCode() {
        
    }
    
    private func setScanHint() {
        
    }
}
