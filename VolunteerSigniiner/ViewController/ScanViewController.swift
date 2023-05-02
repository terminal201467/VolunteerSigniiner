//
//  ScanViewController.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/5/1.
//

import UIKit
import AVFoundation
import SnapKit
import RxSwift
import RxCocoa

class ScanViewController: UIViewController {
    
    @IBOutlet var scanView: UIView!
    
    @IBOutlet var hintView: UIView!
    
    @IBOutlet var closeButton: UIButton!
    
    @IBOutlet var scanedInformation: UILabel!
    
    @IBOutlet var sendButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private var captureSession: AVCaptureSession?
    
    private var previewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        setCapture()
        setPreviewLayer()
        setCloseButtonSubscribe()
        setSendButtonSubscribe()
    }
    
    private func setCapture() {
        captureSession = AVCaptureSession()
        //設置攝像頭
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if ((captureSession?.canAddInput(videoInput)) != nil) {
            captureSession?.addInput(videoInput)
        } else {
            //設置無法開啟攝像頭的時候，彈出提示
            print("無法開啟攝像頭")
            return
        }
        //捕捉QR碼的元數據
        let metadataOutput = AVCaptureMetadataOutput()
        if ((captureSession?.canAddOutput(metadataOutput)) != nil) {
            captureSession?.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            //如果沒有抓到的話可能要報錯，需要設計一下
            print("無法掃描QRCode")
            return
        }
    }
    
    private func setPreviewLayer() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession ?? AVCaptureSession())
        self.previewLayer?.videoGravity = .resizeAspectFill
        self.previewLayer?.frame = self.scanView.layer.bounds
        self.scanView.layer.addSublayer(self.previewLayer ?? AVCaptureVideoPreviewLayer())
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession?.startRunning()
        }
    }
    
    private func setCloseButtonSubscribe() {
        closeButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setSendButtonSubscribe() {
        sendButton.rx.tap
            .subscribe(onNext: {
                //送出到Firebase
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func found(code: String) {
        print("code:\(code)")
        
    }
    
}

extension ScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        if let readableObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
            let stringValue = readableObject.stringValue {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                found(code: stringValue)
        }
        dismiss(animated: true)
    }
}
