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
    
    var menuViewModel: WorkoutMenuViewModel?
    var workoutModel: WorkoutViewModel?
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        menuViewModel = WorkoutMenuViewModel()
        workoutModel = WorkoutViewModel()
        
        print(workoutModel?.viewDidLoad())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
}
