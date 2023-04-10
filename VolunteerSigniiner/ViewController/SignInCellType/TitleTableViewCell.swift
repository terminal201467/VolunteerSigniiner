//
//  TitleTableViewCell.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/4/2.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "TitleCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "VolunteerSigniinner"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    private let manageSystemLabel: UILabel = {
        let label = UILabel()
        label.text = "志工管理系統"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var titleView: UIStackView = {
       let view = UIStackView(arrangedSubviews: [titleLabel, manageSystemLabel])
        view.spacing = 5
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.alignment = .center
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func autoLayout() {
        addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
