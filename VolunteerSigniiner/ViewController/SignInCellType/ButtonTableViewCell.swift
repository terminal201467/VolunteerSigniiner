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
import FBSDKLoginKit
import GoogleSignIn

enum LoginType: Int, CaseIterable {
    case normalSignUp = 0, GooleSignUp, FacebookSignUp, normalLogin, GooleLogin, FacebookLogin, alreadyHaveLeave
    var text: String {
        switch self {
        case .normalSignUp: return "一般註冊"
        case .GooleSignUp: return "Google註冊"
        case .FacebookSignUp: return "Facebook註冊"
        case .normalLogin: return "一般登入"
        case .GooleLogin: return "Google登入"
        case .FacebookLogin: return "Facebooke登入"
        case .alreadyHaveLeave: return "已註冊，回登入頁"
        }
    }
    var icon: String {
        switch self {
        case .normalSignUp: return ""
        case .GooleLogin: return "google"
        case .FacebookLogin: return "facebook"
        case .normalLogin: return ""
        case .GooleSignUp: return "google"
        case .FacebookSignUp: return "facebook"
        case .alreadyHaveLeave: return ""
        }
    }
}

class ButtonTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "ButtonCell"

    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("登入", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 0.5
        button.backgroundColor = .white
        return button
    }()
    
    private let facebookLoginButton: FBLoginButton = {
        let button = FBLoginButton(type: .roundedRect)
        return button
    }()
    
    private let googleLoginButton: GIDSignInButton = {
       let button = GIDSignInButton()
        button.style = .wide
        return button
    }()
    
    private let disposeBag = DisposeBag()
    
    var normalLoginTapSubject = PublishSubject<Void>()
    
    var googleLoginTapSubject = PublishSubject<Void>()
    
    var facebookLoginTapSubject = PublishSubject<String>()
    
    private var loginType: LoginType?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        autoLayout()
        setFBLoginButtonDelegate()
        setGoogleLoginButtonSubscribe()
        setNormalLoginButtonSubscribe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setFBLoginButtonDelegate() {
        facebookLoginButton.delegate = self
    }
    
    private func setGoogleLoginButtonSubscribe() {
        googleLoginButton.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] _ in
                self?.googleLoginTapSubject.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    private func setNormalLoginButtonSubscribe() {
        loginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.normalLoginTapSubject.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    private func autoLayout() {
        contentView.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(160)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    
        contentView.addSubview(googleLoginButton)
        googleLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(facebookLoginButton)
        facebookLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with loginType: LoginType) {
        self.loginType = loginType
        setLogin(with: loginType)
    }
    
    private func setLogin(with type: LoginType) {
        switch type {
        case .normalSignUp:
            facebookLoginButton.isHidden = true
            googleLoginButton.isHidden = true
            loginButton.setTitle("註冊", for: .normal)
        case .normalLogin:
            googleLoginButton.isHidden = true
            facebookLoginButton.isHidden = true
        case .GooleSignUp:
            facebookLoginButton.isHidden = true
            googleLoginButton.isHidden = false
        case .FacebookSignUp:
            facebookLoginButton.isHidden = false
            googleLoginButton.isHidden = true
        case .GooleLogin:
            facebookLoginButton.isHidden = true
            googleLoginButton.isHidden = false
            loginButton.isHidden = true
        case .FacebookLogin:
            facebookLoginButton.isHidden = false
            googleLoginButton.isHidden = true
            loginButton.isHidden = true
        case .alreadyHaveLeave:
            googleLoginButton.isHidden = true
            facebookLoginButton.isHidden = true
            loginButton.isHidden = false
            loginButton.setTitle(type.text, for: .normal)
            loginButton.setTitleColor(.white, for: .normal)
            loginButton.backgroundColor = .orange
        }
    }
}


extension ButtonTableViewCell: LoginButtonDelegate {
    func loginButton(_ loginButton: FBSDKLoginKit.FBLoginButton, didCompleteWith result: FBSDKLoginKit.LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print("Facebook 登錄失敗：\(error.localizedDescription)")
            return
        }
        
        if let accessToken = result?.token?.tokenString {
            facebookLoginTapSubject.onNext(accessToken)
            print("accessToken:\(accessToken)")
        }
        
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        print("logout?")
    }
}
