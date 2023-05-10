//
//  ServiceView.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/5/9.
//

import UIKit

class ServiceView: UIView {

    private let serviceNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30)
        label.roundCorners(cornerRadius: 10)
        label.backgroundColor = .white
        return label
    }()
    
    private let startTimeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let stopTimeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let startTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let stopTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var startTimeStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [startTimeImage, startTimeLabel])
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var stopTimeStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [stopTimeImage, stopTimeLabel])
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.axis = .horizontal
        return stackView
    }()
    
    private lazy var timeStack: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [startTimeStack, stopTimeStack])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func autoLayout() {
        addSubview(serviceNameLabel)
        addSubview(timeStack)
        startTimeImage.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        stopTimeImage.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        serviceNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(timeStack.snp.top).offset(-20)
        }
        
        timeStack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
        }
    }
    
    func configure(withName name: String) {
        serviceNameLabel.text = name
    }
    
    func configure(byStartTime startTime: String?, byStopTime stopTime: String?) {
        setStartTime(by: startTime)
        setStopTime(by: stopTime)
    }
    
    private func setStartTime(by time: String?) {
        if let startTime = time {
            startTimeImage.image = .checkmark.withTintColor(.green)
            startTimeLabel.text = startTime
        } else {
            startTimeImage.image = .remove.withTintColor(.red)
            startTimeLabel.text = "--:--"
        }
    }
    
    private func setStopTime(by time: String?) {
        if let stopTime = time {
            stopTimeImage.image = .checkmark.withTintColor(.green)
            stopTimeLabel.text = stopTime
        } else {
            stopTimeImage.image = .remove.withTintColor(.red)
            stopTimeLabel.text = "未有結束服務時間"
        }
    }
}
