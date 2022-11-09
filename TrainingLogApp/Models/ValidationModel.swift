//
//  ValidattionViewModel.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/04.
//

import Foundation
import RxSwift
import RxCocoa


enum ValidationResult {
    case valid
    case dataIsEmpty(section: String)
    case invalidFormat(section: String)

    var isValid: Bool {
        switch self {
        case .valid:
            return true
        case .dataIsEmpty:
            return false
        case .invalidFormat:
            return false
        }
    }
    var errorMessage: String {
        switch self {
        case .valid:
            return "OK"
        case .dataIsEmpty(let section):
            return "\(section)の入力がありません"
        case .invalidFormat(let section):
            return "\(section)に使用できない文字が含まれています"
        }
    }
}

protocol ValidationProtocol {
    
}

class ValidationModel: ValidationProtocol {
    
    
    func validateText(text: String) -> Bool {

        return text != "" 
    }
    
    func validateTextDouble(text: String) -> Bool {
        return Double(text) != nil
    }
}

