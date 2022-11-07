//
//  RealmObject.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import Foundation
import RealmSwift

class WorkoutRealmObject: Object {
    @objc dynamic var targetPart: String = ""
    @objc dynamic var workoutName: String = ""
    @objc dynamic var weight: Double = 1
    @objc dynamic var reps: Int = 1
    @objc dynamic var doneAt: Date = Date()
    @objc dynamic var volume: Double = 0.0
    @objc dynamic var memo: String = ""
}

// Objectを継承しない、データの削除や更新をするためのstruct
struct WorkoutObject {
    var targetPart: String = ""
    var workoutName: String = ""
    var weight: Double = 1
    var reps: Int = 1
    var doneAt: Date = Date()
    var volume: Double
    var memo: String = ""
    
    init() {
        let obj = WorkoutRealmObject()
        self.targetPart = obj.targetPart
        self.workoutName = obj.workoutName
        self.weight = obj.weight
        self.reps = obj.reps
        self.doneAt = obj.doneAt
        self.volume = obj.volume
        self.memo = obj.memo
    }
    
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
