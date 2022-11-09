//
//  ViewModel.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

protocol FormValidateViewModelInput {
}

protocol ViewModelOutput {
    
}

class FormValidateViewModel: FormValidateViewModelInput {
    
    private let disposeBag = DisposeBag()
    let model = ValidationModel()
    
    // Observable
    var targetTextOutput = PublishSubject<String>()
    var workoutTextOutput = PublishSubject<String>()
    var weightTextOutput = PublishSubject<String>()
    var repsTextOutput = PublishSubject<String>()
    
    var validRegisterSubject = BehaviorSubject<Bool>(value: false)
    
    // Observer
    var targetTextInput: AnyObserver<String> {
        targetTextOutput.asObserver()
    }
    var workoutTextInput: AnyObserver<String> {
        workoutTextOutput.asObserver()
    }
    var weightTextInput: AnyObserver<String> {
        weightTextOutput.asObserver()
    }
    var repsTextInput: AnyObserver<String> {
        repsTextOutput.asObserver()
    }
    
    var validRegisterDriver: Driver<Bool> = Driver.never()
    
    
    init() {
        
        validRegisterDriver = validRegisterSubject.asDriver(onErrorDriveWith: Driver.empty())
        
        let targetValid = targetTextOutput.asObservable().map { text -> Bool in
            return self.model.validateText(text: text)
        }
        
        let workoutValid = workoutTextOutput.asObservable().map { text -> Bool in
            return self.model.validateText(text: text)
        }
        
        let weightValid = weightTextOutput.asObservable().map { text -> Bool in
            return self.model.validateTextDouble(text: text)
        }
        
        let repsValid = repsTextOutput.asObservable().map { text -> Bool in            
            return self.model.validateText(text: text)
        }
        
        Observable.combineLatest(targetValid, workoutValid, weightValid, repsValid) {
            $0 && $1 && $2 && $3
        }.subscribe { validAll in
            self.validRegisterSubject.onNext(validAll)
        }
        .disposed(by: disposeBag)
    }
}

