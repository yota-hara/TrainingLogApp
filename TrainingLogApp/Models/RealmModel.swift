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
        print(#function)
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
            let workout = realmObj.toWorkoutObject()
            workoutArray.append(workout)
        }
        return workoutArray
    }
}
