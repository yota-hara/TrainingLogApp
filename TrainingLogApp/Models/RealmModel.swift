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
    
    public func getWorkout(doneAtDate: Date) -> [WorkoutObject] {
        var workoutArray = [WorkoutObject]()
        let realm = try! Realm()
        let workoutDataArray = realm.objects(WorkoutRealmObject.self).filter { realmObject in
            realmObject.doneAt == DateUtils.toStringFromDate(date: doneAtDate)
        }
        for realmObj in workoutDataArray {
            let workout = realmObj.toWorkoutObject()
            workoutArray.append(workout)
        }
        return workoutArray
    }
    
    public func deleteAll() {
        let realm = try! Realm()
        let realmData = realm.objects(WorkoutRealmObject.self)
        do {
            try realm.write {
            realm.delete(realmData)
            }
        } catch {
            print("delete error")
        }
        
    }
}
