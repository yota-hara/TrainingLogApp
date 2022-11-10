//
//  RealmModel.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import Foundation
import RealmSwift

class RealmModel {
    
    public func saveWorkout(with workout: WorkoutObject) {
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(workout.toRealmObject())
        try! realm.commitWrite()
    }
    
    public func deleteWorkout(with workout: WorkoutObject) {
        let realm = try! Realm()
        realm.beginWrite()

        try! realm.commitWrite()
    }
    
    public func getWorkout() -> [WorkoutObject] {
        var workoutArray = [WorkoutObject]()
        let realm = try! Realm()
        let workoutDataArray = realm.objects(WorkoutRealmObject.self)
        for realmObj in workoutDataArray {
            var workout = WorkoutObject()
            workout.targetPart = realmObj.targetPart
            workout.workoutName = realmObj.workoutName
            workout.weight = realmObj.weight
            workout.reps = realmObj.reps
            workout.doneAt = realmObj.doneAt
            workout.volume = realmObj.volume
            workout.memo = realmObj.memo
            workoutArray.append(workout)
        }
        return workoutArray
    }
}


