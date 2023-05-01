//
//  HomeViewController.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/4/28.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class HomeViewController: UIViewController {
    
    @IBOutlet var helloAndNameLabel: UILabel!
    
    @IBOutlet var qrCodeImage: UIImageView?
    
    @IBOutlet var reloadButton: UIButton!
    
    @IBOutlet var scanHintLabel: UILabel!
    
    @IBOutlet var logOutButton: UIButton!
    
    private let firebaseAuth = FirebaseAuthService()
    
    private let qrcodeService = QRCodeService()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavationBar()
        setNameLabel()
        setQRCodeImage()
        setReloadButton()
        setScanHint()
        setLogOutButton()
        print(
            """
            \(firebaseAuth.getCurrentUser()?.uid),
            \(firebaseAuth.getCurrentUser()?.email),
            \(firebaseAuth.getCurrentUser()?.displayName)
            """
            )
    }
    
    private func setReloadButton() {
        reloadButton.setTitle("重新產生QRCode", for: .normal)
        reloadButton.rx.tap
            .subscribe(onNext: {
                self.regenerateQRCode()
            })
            .disposed(by: disposeBag)
    }
    
    private func setNavationBar() {
        navigationItem.hidesBackButton = true
    }
    
    private func setNameLabel() {
        if let name = firebaseAuth.getCurrentUser()?.displayName {
            helloAndNameLabel.text = "Hi，\(name)"
        }
    }
    
    private func setQRCodeImage() {
        if let uid = firebaseAuth.getCurrentUser()?.uid {
            qrCodeImage?.image = qrcodeService.createQRCode(uid: uid)
            reloadButton.isHidden = true
        } else {
            reloadButton.isHidden = false
        }
    }
    
    private func regenerateQRCode() {
        if qrCodeImage == nil {
            if let uid = firebaseAuth.getCurrentUser()?.uid {
                qrCodeImage?.image = qrcodeService.createQRCode(uid: uid)
            }
        }
    }
    
    private func setScanHint() {
        scanHintLabel.text = "請掃描上面的QRcode"
    }
    
    private func setLogOutButton() {
        logOutButton.setTitle("登出", for: .normal)
        logOutButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
