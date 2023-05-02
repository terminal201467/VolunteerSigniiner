//
//  AccountCheckHelper.swift
//  VolunteerSigniiner
//
//  Created by Jhen Mu on 2023/5/2.
//

import Foundation

enum VerifyState: Int, CaseIterable {
    case verify = 0, unverify
    var acountVerify: String {
        switch self {
        case .verify: return "通過驗證"
        case .unverify: return "您的帳號不完整"
        }
    }
    var passwordVerify: String {
        switch self {
        case .verify: return "通過驗證"
        case .unverify: return "密碼字數不足"
        }
    }
    
    var checkAccountAndPasswordVerify: String {
        switch self {
        case .verify: return "已填寫"
        case .unverify: return "未填寫"
        }
    }
}

enum FillState: Int, CaseIterable {
    case acountUnfill = 0, passwordUnfill, bothUnfill, fillComplete
    var text: String {
        switch self {
        case .acountUnfill: return "帳號未填寫"
        case .passwordUnfill: return "密碼未填寫"
        case .bothUnfill: return "帳號與密碼皆未填寫"
        case .fillComplete: return "填寫完成"
        }
    }
}

class AccountCheckHelper {
    
    //MARK: - Check Account and Password
    func checkBothAcountAndPassword(with account: String, with password: String) -> FillState {
        if account == "" && password == "" {
            return .bothUnfill
        } else if account == "" {
            return .acountUnfill
        } else if password == "" {
            return .passwordUnfill
        } else {
            return .fillComplete
        }
    }
    
    func checkAccount(with text: String) -> VerifyState {
        let validSuffixes = [".com", ".com.tw"]
        if let domain = text.components(separatedBy: "@").last {
            for suffix in validSuffixes {
                if domain.hasSuffix(suffix) {
                    return .verify
                }
            }
        }
        return .unverify
    }

    func checkPassword(with text: String) -> VerifyState {
        return text.count < 10 ? VerifyState.unverify : VerifyState.verify
    }
    
}
