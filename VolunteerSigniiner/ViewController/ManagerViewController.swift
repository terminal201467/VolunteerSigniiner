//
//  ManagerViewController.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/5/1.
//

import UIKit
import RxCocoa
import RxSwift

class ManagerViewController: UIViewController {
    
    @IBOutlet var helloAndNameLabel: UILabel!
    
    @IBOutlet var attendButton: UIButton!
    
    @IBOutlet var serviceQRCodeButton: UIButton!
    
    @IBOutlet var outputFileButton: UIButton!
    
    @IBOutlet var buttons: UIStackView!
    
    private let disposeBag = DisposeBag()
    
    private var attendActiveViewController: AttendActiveViewController?
    
    private var serviceQRcodeViewController: ServiceQRCodeViewController?
    
    private var outputViewController: OutputFileViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
//        setButtons()
        setNavationBar()
        setButtonRxSubscribe()
        // Do any additional setup after loading the view.
    }
    
    //這個頁面主要是做管理志工的相關工作
    
    //功能：
    //1. 跳出據點QRCode的頁面（ScanViewController）
    
    //2. 志工參與人數（月、季、年參與狀況）
    
    //3. 輸出CSV檔
    
    //4. 可以顯示近期服務打卡志工的參與記錄
        //並且可以增刪修查相關服務
    private func setNavationBar() {
        navigationItem.hidesBackButton = true
    }
    
    private func setButtonRxSubscribe() {
        attendButton.rx.tap
            .subscribe(onNext: {
                //跳出志工參與狀態頁面
                self.attendActiveViewController = AttendActiveViewController()
                self.navigationController?.pushViewController(self.attendActiveViewController!, animated: true)
            })
            .disposed(by: disposeBag)
        
        serviceQRCodeButton.rx.tap
            .subscribe(onNext: {
                //跳出據點QRCode的頁面
                self.serviceQRcodeViewController = ServiceQRCodeViewController()
                self.navigationController?.pushViewController(self.serviceQRcodeViewController!, animated: true)
            })
            .disposed(by: disposeBag)
        
        outputFileButton.rx.tap
            .subscribe(onNext: {
                self.outputViewController = OutputFileViewController()
                self.navigationController?.pushViewController(self.outputViewController!, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setButtons() {
        attendButton.setImage(UIImage(named: "people"), for: .normal)
        serviceQRCodeButton.setImage(UIImage(named: "qrcode"), for: .normal)
        outputFileButton.setImage(UIImage(named: "outputFile"), for: .normal)
    }
    
    private func setLabelAndStackView(with name: String) {
        helloAndNameLabel.text = "Hi，\(name)"
        buttons.roundCorners(cornerRadius: 100)
    }

}
