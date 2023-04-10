//
//  TextFieldTableViewCell.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/4/2.
//

import UIKit
import RxSwift
import RxRelay


class TextFieldTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "TextFieldCell"
    
    private let disposeBag = DisposeBag()

    let inputer: UITextField = {
       let textField = UITextField()
        textField.clearButtonMode = .whileEditing
        textField.becomeFirstResponder()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    public var textVariable = BehaviorRelay<String>(value: "")
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        autoLayout()
        setTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func autoLayout() {
        contentView.addSubview(inputer)
        inputer.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview().offset(-5)
        }
    }
    
    private func setTextField() {
        inputer.rx.text.orEmpty
            .bind(to: textVariable)
            .disposed(by: disposeBag)
        textVariable.asObservable()
            .bind(to: inputer.rx.text)
            .disposed(by: disposeBag)
    }
    
}
