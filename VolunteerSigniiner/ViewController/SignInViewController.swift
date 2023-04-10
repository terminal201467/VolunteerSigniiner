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

enum CellType {
    case title(String)
    case acountInputer(textVariable: BehaviorRelay<String>)
    case passwordInputer(textVariable: BehaviorRelay<String>)
    case SignInButton
    case GoogleSignUp
    case FaceBookSignUp
}


extension BehaviorRelay: Equatable where Element: Equatable {
    public static func == (lhs: BehaviorRelay<Element>, rhs: BehaviorRelay<Element>) -> Bool {
        return lhs.value == rhs.value
    }
}


class SignInViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    private let disposeBag = DisposeBag()
    
    private let viewModel = LoginViewModel()
    
    private lazy var cellType:[CellType] = [.title("SignIn"),
                               .acountInputer(textVariable: viewModel.accountInputChanged),
                               .passwordInputer(textVariable: viewModel.passwordInputChanged),
                               .SignInButton,
                               .GoogleSignUp,
                               .FaceBookSignUp]

    override func viewDidLoad() {
        super.viewDidLoad()
        setTable()
        setTableDataSource()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Void,CellType>> { dataSources, tableView, indexPath, item in
            switch item {
            case .title:
                let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.reuseIdentifier, for: indexPath) as! TitleTableViewCell
                cell.selectionStyle = .none
                return cell
            case .acountInputer:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
                cell.selectionStyle = .none
                cell.inputer.placeholder = "帳號"
                cell.textVariable = self.viewModel.accountInputChanged
                return cell
            case .passwordInputer:
                let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldTableViewCell.reuseIdentifier, for: indexPath) as! TextFieldTableViewCell
                cell.selectionStyle = .none
                cell.inputer.placeholder = "密碼"
                cell.textVariable = self.viewModel.passwordInputChanged
                return cell
            case .SignInButton:
                let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: indexPath) as! ButtonTableViewCell
                //一般註冊
                cell.selectionStyle = .none
                cell.configure(with: .normal)
                cell.tapSubject = self.viewModel.loginButtonLoginTapped
                return cell
            case .GoogleSignUp:
                let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: indexPath) as! ButtonTableViewCell
                //Google註冊
                cell.selectionStyle = .none
                cell.configure(with: .GooleLogin)
                cell.tapSubject = self.viewModel.thirdPartyButtonLoginTapped
                return cell
            case .FaceBookSignUp:
                let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: indexPath) as! ButtonTableViewCell
                //Facebook註冊
                cell.selectionStyle = .none
                cell.configure(with: .FacebookLogin)
                cell.tapSubject = self.viewModel.thirdPartyButtonLoginTapped
                return cell
            }
        }
        
        Observable.just(cellType)
            .map { [SectionModel(model: (), items: $0)] }
            .bind(to: table.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
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
