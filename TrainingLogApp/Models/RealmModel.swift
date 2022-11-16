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
        let realmObject = workout.toRealmObject()
        let result = realm.objects(WorkoutRealmObject.self).filter {
            $0.targetPart == realmObject.targetPart &&
            $0.workoutName == realmObject.workoutName &&
            $0.weight == realmObject.weight &&
            $0.reps == realmObject.reps &&
            $0.doneAt == realmObject.doneAt &&
            $0.volume == realmObject.volume &&
            $0.memo == realmObject.memo
        }.first
        
        if result == nil {
            print("Already Deleted")
        } else {
            do {
                try realm.write {
                    realm.delete(result!)
                }
            } catch {
                print("delete error")
            }
        }

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
    
    public func updateWorkout(from workout: WorkoutObject, to newWorkout: WorkoutObject) {
        let realm = try! Realm()
        let realmObject = workout.toRealmObject()
        let result = realm.objects(WorkoutRealmObject.self).filter {
            $0.targetPart == realmObject.targetPart &&
            $0.workoutName == realmObject.workoutName &&
            $0.weight == realmObject.weight &&
            $0.reps == realmObject.reps &&
            $0.doneAt == realmObject.doneAt &&
            $0.volume == realmObject.volume &&
            $0.memo == realmObject.memo
        }.first
        
        do{
          try realm.write{
              realm.delete(result!)
              realm.add(newWorkout.toRealmObject())
          }
        }catch {
          print("Error \(error)")
        }
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
