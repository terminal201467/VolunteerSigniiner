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
    
    @IBOutlet var helloNameLabel: UILabel!
    
    @IBOutlet var recordTimeButton: UIButton!
    
    @IBOutlet var sendOutButton: UIButton!
    
    @IBOutlet var hintView: UIView!
    
    private let notServiceView = NotBeginServiceView()
    
    private let serviceView = ServiceView()
    
    private let viewModel = VolunteerViewModel()
    
    private let disposeBag = DisposeBag()
    
    private var scanViewController: ScanViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHelloLabel()
        setNavationBar()
        setButtonStyle()
        setButtonSubscribe()
        setNotBeginView()
    }
    
    private func setHelloLabel() {
        helloNameLabel.text = "Hi，\(viewModel.getUserName())"
    }
    
    private func setNavationBar() {
        navigationItem.hidesBackButton = true
    }
    
    private func setButtonStyle() {
        hintView.roundCorners(cornerRadius: 5)
        recordTimeButton.roundCorners(cornerRadius: 10)
        sendOutButton.roundCorners(cornerRadius: 10)
    }
    
    private func setButtonSubscribe() {
        recordTimeButton.rx.tap
            .subscribe(onNext: {
                self.scanViewController = ScanViewController()
                self.navigationController?.pushViewController(self.scanViewController!, animated: true)
                self.scanViewController?.scanValue = { uid in
                    if self.viewModel.isBeginService {
                        self.viewModel.storeLastServiceInfo(serviceID: uid)
                        self.setTimeConfigure()
                    } else {
                        self.viewModel.storeStartServiceInfo(serviceID: uid)
                        self.viewModel.sendOutFirstRecord(serviceID: uid)
                        self.removeNotServiceView()
                        self.setBeginServiceView()
                        self.setTimeConfigure()
                        self.setStoreButton(by: false)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        sendOutButton.rx.tap
            .subscribe(onNext: {
                self.viewModel.sendOutLastServiceRecord()
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setStoreButton(by sendType: Bool) {
        if sendType {
            recordTimeButton.setTitle("開始志願服務", for: .normal)
        } else {
            recordTimeButton.setTitleColor(.red, for: .normal)
            recordTimeButton.setTitle("結束志願服務", for: .normal)
            recordTimeButton.setImage(.remove, for: .normal)
            recordTimeButton.tintColor = .red
        }
    }
    
    private func setNotBeginView() {
        hintView.addSubview(notServiceView)
        notServiceView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setBeginServiceView() {
        hintView.addSubview(serviceView)
        serviceView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func removeNotServiceView() {
        notServiceView.removeFromSuperview()
    }
    
    private func removeServiceView() {
        serviceView.removeFromSuperview()
    }
    
    private func setServiceName(with uid: String) -> String {
        switch uid {
        case ServiceType.farmService.typeID:                return ServiceType.farmService.typeName
        case ServiceType.huiLaiElderService.typeID:         return ServiceType.huiLaiElderService.typeName
        case ServiceType.huilaiDisablePeopleService.typeID: return ServiceType.huilaiDisablePeopleService.typeName
        case ServiceType.pengChengService.typeID:           return ServiceType.pengChengService.typeName
        case ServiceType.fundrasingService.typeID:          return ServiceType.fundrasingService.typeName
        default: return "沒有服務"
        }
    }
    
    private func setTimeConfigure() {
        let startTime = viewModel.getFirstServiceInfo()?.timeStamp
        let lastTime = viewModel.getLastServiceInfo()?.timeStamp
        serviceView.configure(withName: setServiceName(with: viewModel.getFirstServiceInfo()?.uid ?? "未知的服務"))
        serviceView.configure(byStartTime: startTime, byStopTime: lastTime)
    }
}
