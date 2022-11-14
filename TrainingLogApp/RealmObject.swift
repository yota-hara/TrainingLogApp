//
//  RealmObject.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import RealmSwift

class WorkoutRealmObject: Object {
    @objc dynamic var targetPart: String = ""
    @objc dynamic var workoutName: String = ""
    @objc dynamic var weight: Double = 1
    @objc dynamic var reps: Int = 1
    @objc dynamic var doneAt: String = ""
    @objc dynamic var volume: Double = 1
    @objc dynamic var memo: String = ""
    
    func toWorkoutObject() -> WorkoutObject {
        var workout = WorkoutObject()
        workout.targetPart = self.targetPart
        workout.workoutName = self.workoutName
        workout.weight = self.weight
        workout.reps = self.reps
        workout.doneAt = self.doneAt
        workout.volume = self.volume
        workout.memo = self.memo
        return workout
    }
}

struct WorkoutObject {
    var targetPart: String = ""
    var workoutName: String = ""
    var weight: Double = 1
    var reps: Int = 1
    var doneAt: String = ""
    var volume: Double = 0
    var memo: String = ""
    
    // Object継承クラス型に変換するメソッド
    func toRealmObject() -> WorkoutRealmObject {
        let obj = WorkoutRealmObject()
        obj.targetPart = self.targetPart
        obj.workoutName = self.workoutName
        obj.weight = self.weight
        obj.reps = self.reps
        obj.doneAt = self.doneAt
        obj.volume = self.volume
        obj.memo = self.memo
        return obj
    }
}

class WorkoutMenu: Object {
    @objc dynamic var targetPart: String = ""
    var workoutNames = List<WorkoutName>()
    
}

class WorkoutName: Object {
    @objc dynamic var workoutName: String = ""
    
}
