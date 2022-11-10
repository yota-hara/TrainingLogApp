//
//  WorkoutViewModel.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/02.
//

import RxSwift
import RxRelay
import Accessibility

class WorkoutViewModel {
    
    var workoutCellViewModels = BehaviorRelay<[WorkoutCellViewModel]>(value: [])
    let model = RealmModel()
    
    func onTapRegister(target: String, workoutName: String, weight: String, reps: String, memo: String) {
        var workout = WorkoutObject()
        workout.targetPart = target
        workout.workoutName = workoutName
        workout.weight = Double(weight)!
        workout.reps = Int(reps)!
        workout.volume = Double(Double(weight)! * Double(reps)!)
        workout.memo = memo
        
        let workoutCellViewModel = WorkoutCellViewModel(workoutObject: workout)
        workoutCellViewModels.accept([workoutCellViewModel])
        model.saveWorkout(with: workout)
    }

    func viewDidLoad(){
        let workoutArray = model.getWorkout().map { WorkoutCellViewModel(workoutObject: $0)}
        workoutCellViewModels.accept(workoutArray)
    }
}

