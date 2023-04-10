//
//  ButtonTableViewCell.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/4/2.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SnapKit

enum LoginType: Int, CaseIterable {
    case normal = 0, GooleLogin, FacebookLogin
    var text: String {
        switch self {
        case .normal: return "一般註冊"
        case .GooleLogin: return "Google註冊"
        case .FacebookLogin: return "Facebooke註冊"
        }
    }
    var icon: String {
        switch self {
        case .normal: return ""
        case .GooleLogin: return "google"
        case .FacebookLogin: return "facebook"
        }
    }
}

class ButtonTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "ButtonCell"

    private let loginLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    private let loginLogo = UIImageView()
    
    private lazy var loginTitleView: UIStackView = {
       let view = UIStackView(arrangedSubviews: [loginLogo,loginLabel])
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.axis = .horizontal
        view.spacing = 5
        return view
    }()
    
    private let disposeBag = DisposeBag()
    
    private let tapGesture = UITapGestureRecognizer()
    
    var tapSubject = PublishSubject<Void>()
    
    private var loginType: LoginType?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        autoLayout()
        setGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func autoLayout() {
        
        addSubview(loginLabel)
        loginLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(120)
        }
        
        addSubview(loginLogo)
        loginLogo.snp.makeConstraints { make in
            make.height.width.equalTo(30)
        }
        
        addSubview(loginTitleView)
        loginTitleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
    }
    
    private func setGesture() {
        loginTitleView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.tapSubject.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    func configure(with loginType: LoginType) {
        self.loginType = loginType
        setLogin(with: loginType)
    }
    
    private func setLogin(with type: LoginType) {
        switch type {
        case .normal:
            loginLogo.isHidden = true
            loginLabel.text = LoginType.normal.text
        case .GooleLogin:
            loginLogo.isHidden = false
            loginLogo.image = UIImage(named: LoginType.GooleLogin.icon)
            loginLabel.text = LoginType.GooleLogin.text
        case .FacebookLogin:
            loginLogo.isHidden = false
            loginLogo.image = UIImage(named: LoginType.FacebookLogin.icon)
            loginLabel.text = LoginType.FacebookLogin.text
        }
    }
}
