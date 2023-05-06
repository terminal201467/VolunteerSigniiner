//
//  LoginViewController.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/4/25.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources
import SnapKit

enum LoginCellType {
    case title(String)
    case acountInputer(textVariable: BehaviorRelay<String>)
    case passwordInputer(textVariable: BehaviorRelay<String>)
    case loginButton
    case GoogleLogin
    case FaceBookLogin
}

class LoginViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    private let notSignUpButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = LoginViewModel()
    
    private lazy var cellType:[LoginCellType] = [.title("SignIn"),
                               .acountInputer(textVariable: viewModel.accountInputChanged),
                               .passwordInputer(textVariable: viewModel.passwordInputChanged),
                               .loginButton,
                               .GoogleLogin,
                               .FaceBookLogin]

    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        setButton()
        setTableDataSource()
        autoLayout()
        setNavationBar()
        setToHomeViewController()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setNavationBar() {
        navigationItem.hidesBackButton = true
    }
    
    private func setButton() {
        notSignUpButton.setTitle("還沒有註冊嗎？可以點擊這裡註冊！", for: .normal)
        notSignUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        notSignUpButton.setTitleColor(.brown, for: .normal)
        notSignUpButton.rx.tap
            .subscribe(onNext: {
                print("Button tappped!")
                let signUpViewController = SignInViewController()
                self.navigationController?.pushViewController(signUpViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func autoLayout() {
        view.addSubview(notSignUpButton)
        notSignUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(table.snp.bottom)
        }
    }
    
    private func setTable() {
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.reuseIdentifier)
        table.register(TextFieldTableViewCell.self, forCellReuseIdentifier: TextFieldTableViewCell.reuseIdentifier)
        table.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.reuseIdentifier)
        table.estimatedRowHeight = 44 // 設置預估的行高
        table.rowHeight = UITableView.automaticDimension // 設置自動調整行高
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.rx.setDelegate(self).disposed(by: disposeBag)
        self.view.addSubview(table)
    }
    
    private func setTableDataSource() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Void, LoginCellType>> { dataSources, tableView, indexPath, item in
            switch item {
            case .title:
                let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseIdentifier, for: indexPath) as! TitleTableViewCell
                cell.selectionStyle = .none
                return cell
            case .acountInputer:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
                cell.selectionStyle = .none
                cell.inputer.placeholder = "帳號"
                cell.inputer.rx.text
                    .orEmpty
                    .bind(to: self.viewModel.accountInputChanged)
                    .disposed(by: self.disposeBag)
                return cell
            case .passwordInputer:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
                cell.selectionStyle = .none
                cell.inputer.placeholder = "密碼"
                cell.inputer.rx.text
                    .orEmpty
                    .bind(to: self.viewModel.passwordInputChanged)
                    .disposed(by: self.disposeBag)
                return cell
            case .loginButton:
                let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: indexPath) as! ButtonTableViewCell
                //一般註冊
                cell.selectionStyle = .none
                cell.configure(with: .normalLogin)
                cell.normalLoginTapSubject.subscribe(onNext: {
                    self.viewModel.loginButtonLoginTapped.onNext(())
                })
                return cell
            case .GoogleLogin:
                let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: indexPath) as! ButtonTableViewCell
                //Google註冊
                cell.selectionStyle = .none
                cell.configure(with: .GooleLogin)
                cell.googleLoginTapSubject.subscribe(onNext: {
                    self.viewModel.googleSignInTapped.onNext(self)
                })
                return cell
            case .FaceBookLogin:
                let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: indexPath) as! ButtonTableViewCell
                //Facebook註冊
                cell.selectionStyle = .none
                cell.configure(with: .FacebookLogin)
                cell.facebookLoginTapSubject.subscribe(onNext: { accessToken in
                    self.viewModel.facebookSignInTapped.onNext((accessToken))
                })
                return cell
            }
        }
        
        Observable.just(cellType)
            .map { [SectionModel(model: (), items: $0)] }
            .bind(to: self.table.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func setToHomeViewController() {
        viewModel.loginResponse = { response in
            if response == "登入成功" || response == "true"{
//                let qrCodeViewController = QRCodeViewController()
//                self.navigationController?.pushViewController(qrCodeViewController, animated: true)
                //先判斷是管理者還是一般登入
                let managerViewController = ManagerViewController()
                self.navigationController?.pushViewController(managerViewController, animated: true)
                
                
            } else {
                print("請再重新登入")
            }
        }
    }
}

extension LoginViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //這邊可能之後要盡量不寫死
        switch indexPath.item {
        case 0: return 100
        case 1: return 60
        case 2: return 60
        case 3: return 50
        case 4: return 50
        case 5: return 50
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.endEditing(true)
    }
}
