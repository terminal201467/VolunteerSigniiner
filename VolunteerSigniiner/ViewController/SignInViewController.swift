//
//  SignInViewController.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/4/2.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import RxDataSources
import SnapKit

enum SignUpCellType {
    case title(String)
    case acountInputer(textVariable: BehaviorRelay<String>)
    case passwordInputer(textVariable: BehaviorRelay<String>)
    case signInButton
    case alreadyHaveButton
}


extension BehaviorRelay: Equatable where Element: Equatable {
    public static func == (lhs: BehaviorRelay<Element>, rhs: BehaviorRelay<Element>) -> Bool {
        return lhs.value == rhs.value
    }
}


class SignInViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    private let alreadyHaveButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = SignUpViewModel()
    
    private lazy var cellType:[SignUpCellType] = [.title("SignIn"),
                               .acountInputer(textVariable: viewModel.accountInputChanged),
                               .passwordInputer(textVariable: viewModel.passwordInputChanged),
                               .signInButton,
                               .alreadyHaveButton]

    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        setTableDataSource()
//        setButton()
        autoLayout()
        setToLoginViewController()
        setNavationBar()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setNavationBar() {
        navigationItem.hidesBackButton = true
    }
    
//    private func setButton() {
//        alreadyHaveButton.setTitle("已經有帳戶了嗎？點擊這裡直接登入", for: .normal)
//        alreadyHaveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//        alreadyHaveButton.setTitleColor(.brown, for: .normal)
//        alreadyHaveButton.rx.tap
//            .subscribe(onNext: {
//                print("Button tappped!")
//                let loginViewController = LoginViewController()
//                self.navigationController?.pushViewController(loginViewController, animated: true)
//            })
//            .disposed(by: disposeBag)
//    }
    
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
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Void,SignUpCellType>> { dataSources, tableView, indexPath, item in
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
            case .signInButton:
                let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: indexPath) as! ButtonTableViewCell
                //一般註冊
                cell.selectionStyle = .none
                cell.configure(with: .normalSignUp)
                cell.normalLoginTapSubject.subscribe(onNext: {
                    self.viewModel.loginButtonLoginTapped.onNext(())
                })
                .disposed(by: self.disposeBag)
                return cell
            case .alreadyHaveButton:
                let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: indexPath) as! ButtonTableViewCell
                //一般註冊
                cell.selectionStyle = .none
                cell.configure(with: .alreadyHaveLeave)
                cell.normalLoginTapSubject.subscribe(onNext: {
                    self.navigationController?.popViewController(animated: true)
                })
                .disposed(by: self.disposeBag)
                return cell
            }
        }
        
        Observable.just(cellType)
            .map { [SectionModel(model: (), items: $0)] }
            .bind(to: table.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func autoLayout() {
        view.addSubview(alreadyHaveButton)
        alreadyHaveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(table.snp.bottom)
        }
    }
    
    private func setToLoginViewController() {
        viewModel.pushToController = {
            self.presentedViewController?.dismiss(animated: true)
            let loginViewController = LoginViewController()
            self.navigationController?.pushViewController(loginViewController, animated: true)
        }
    }
}

extension SignInViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.item {
        case 0: return 100
        case 1: return 60
        case 2: return 60
        default: return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.endEditing(true)
    }
}
