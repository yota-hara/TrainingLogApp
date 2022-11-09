//
//  RegisterMenuController.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterMenuController: UIViewController {
    
    // MARK: - Properties & UIParts
    
    var workoutMenuViewModel: WorkoutMenuViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        workoutMenuViewModel = WorkoutMenuViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
}
