//
//  VolunteerViewController.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/5/3.
//

import UIKit
import RxCocoa
import RxSwift

class VolunteerViewController: UIViewController {
    
//    @IBOutlet var qrcodeButton: UIButton!
    
    @IBOutlet var helloNameLabel: UILabel!
    
    @IBOutlet var recordTimeButton: UIButton!
    
    @IBOutlet var hintView: UIView!
    
    private let disposeBag = DisposeBag()
    
    private var scanViewController: ScanViewController?
    
//    private var qrcodeViewController: QRCodeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonStyle()
        setButtonSubscribe()

    }
    
    private func setButtonStyle() {
        hintView.roundCorners(cornerRadius: 5)
        recordTimeButton.roundCorners(cornerRadius: 10)
    }
    
    private func setButtonSubscribe() {
        recordTimeButton.rx.tap
            .subscribe(onNext: {
                self.scanViewController = ScanViewController()
                self.navigationController?.pushViewController(self.scanViewController!, animated: true)
                self.scanViewController?.scanValue = { uid in
                    print(uid)
                }
            })
            .disposed(by: disposeBag)
    }

    
    //這邊有幾個功能：
    
    //1.顯示今天參與服務與開始打卡時間、結束打卡時間
        //今天如果已經打了上工卡，那就要顯示今天打卡時間
        //下班卡，也顯示下打卡時間
    
    //2.可以選擇要開QRCode掃描器 或是 顯示使用者的QRcode
        // 顯示使用者的QRCode這點我還沒有什麼想法(請管理者幫打卡)
    
    
}
