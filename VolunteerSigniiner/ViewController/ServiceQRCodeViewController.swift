//
//  ServiceQRCodeViewController.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/5/6.
//

import UIKit
import RxSwift
import RxCocoa

enum ServiceType: Int {
    case farmService = 0, pengChengService, huiLaiElderService, huilaiDisablePeopleService,fundrasingService
    var typeID: String {
        switch self {
        case .farmService: return ServicesManager.farmServiceLoginID
        case .pengChengService: return ServicesManager.pengChengServiceLoginID
        case .huiLaiElderService: return ServicesManager.huiLaiElderSeerviceLoginID
        case .huilaiDisablePeopleService: return ServicesManager.huiLaiDisablePeopleServiceLoginID
        case .fundrasingService: return ServicesManager.fundraisingServiceLoginID
        }
    }
    var typeName: String {
        switch self {
        case .farmService: return "農場服務"
        case .pengChengService: return "鵬程據點服務"
        case .huiLaiElderService: return "惠來老人服務"
        case .huilaiDisablePeopleService: return "惠來身障服務"
        case .fundrasingService: return "募款產品服務"
        }
    }
}

class ServiceQRCodeViewController: UIViewController {
    
    @IBOutlet var serviceKind: UISegmentedControl!
    
    @IBOutlet var qrcodeContainerView: UIView!
    
    @IBOutlet var qrCodeImageView: UIImageView!
    
    @IBOutlet var serviceName: UILabel!
    
    @IBOutlet var returnButton: UIButton!
    
    private let qrcodeService = QRCodeService()
    
    private let selectedIndex = PublishRelay<Int>()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavationBar()
        setSegmentControl()
        setReturnButton()
        setRoundView()
        setQRCodeImageAndServiceName(by: .farmService)
        // Do any additional setup after loading the view.
    }
    
    private func setNavationBar() {
        navigationItem.hidesBackButton = true
    }
    private func setSegmentControl() {
        serviceKind.rx.controlEvent(.valueChanged)
            .map { [weak self] in
                self?.serviceKind.selectedSegmentIndex ?? 0
            }
            .bind(to: selectedIndex)
            .disposed(by: disposeBag)
        
        selectedIndex.subscribe(onNext: { index in
            self.setQRCodeImageAndServiceName(by: ServiceType(rawValue: index) ?? ServiceType.farmService)
        })
        .disposed(by: disposeBag)
    }
    
    private func setRoundView() {
        qrcodeContainerView.roundCorners(cornerRadius: 10)
        serviceName.roundCorners(cornerRadius: 10)
    }
    
    private func setQRCodeImageAndServiceName(by type: ServiceType) {
        qrCodeImageView.image = qrcodeService.createQRCode(uid: type.typeID)
        serviceName.text = type.typeName
    }
    
    private func setReturnButton() {
        returnButton.rx.tap
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }

}
