//
//  RecordWorkoutController.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit
import RxSwift
import RxCocoa

class RecordWorkoutController: UIViewController {
    
    // MARK: - Properties & UIParts
    
    var workoutMenuViewModel: WorkoutMenuViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        workoutMenuViewModel = WorkoutMenuViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
}
