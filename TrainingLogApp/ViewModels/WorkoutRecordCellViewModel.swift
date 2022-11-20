//
//  WorkoutCellViewModel.swift
//  TrainingLogApp
//
//  Created by 田原葉 on 2022/11/10.
//

import RealmSwift

class WorkoutRecordCellViewModel {
    
    var workoutObject: WorkoutObject

    init(workoutObject: WorkoutObject) {
        self.workoutObject = workoutObject
    }
}
 
