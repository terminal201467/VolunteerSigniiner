//
//  NotBeginServiceView.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/5/9.
//

import UIKit

class NotBeginServiceView: UIView {

    private let notYetServiceLabel: UILabel = {
       let label = UILabel()
        label.text = "你還未開始志願服務"
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    private let hintLabel: UILabel = {
       let label = UILabel()
        label.text = "請點選下方按鈕"
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .brown
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [notYetServiceLabel, hintLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
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
        addSubview(labelStack)
        labelStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
