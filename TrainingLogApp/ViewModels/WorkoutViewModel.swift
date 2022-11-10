//
//  WorkoutViewModel.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/02.
//

import Foundation

class WorkoutViewModel {
    
    let model = RealmModel()
    
    func onTapRegister(target: String, workoutName: String, weight: String, reps: String, memo: String) {
        var workout = WorkoutObject()
        workout.targetPart = target
        workout.workoutName = workoutName
        workout.weight = Double(weight)!
        workout.reps = Int(reps)!
        workout.memo = memo
        model.saveWorkout(with: workout)
    }

    func viewDidLoad() -> [WorkoutObject] {
        var workoutArray = [WorkoutObject]()
        workoutArray = model.getWorkout()
        return workoutArray
    }
}
