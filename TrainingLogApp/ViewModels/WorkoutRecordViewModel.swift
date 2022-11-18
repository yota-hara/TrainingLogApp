//
//  WorkoutViewModel.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/02.
//

import RxSwift
import RxRelay

class WorkoutRecordViewModel {
    
    private let dateRelay = BehaviorRelay<Date>(value: Date())
    var currentDate: Observable<Date> {
        return dateRelay.share().asObservable()
    }
        
    private let items = BehaviorRelay<[WorkoutRecordCellViewModel]>(value: [])
    var itemObservable: Observable<[WorkoutRecordCellViewModel]> {
        return items.asObservable()
    }
    
    private let model = RealmModel()
    private let disposeBag = DisposeBag()
    private var menuArray: [WorkoutMenu] = []
    
    // recordFormの出現状態
    var recordFormApear = BehaviorRelay<Bool>(value: false)
    
    init(menuArray: [WorkoutMenu]) {
        self.menuArray = menuArray
        updateItems()
    }
    
    func updateItems() {
        let workoutArray = model.getWorkout(doneAtDate: dateRelay.value)
        let sortedWorkoutArray = sortItems(workoutArray: workoutArray)
        let newItems = sortedWorkoutArray.map { WorkoutRecordCellViewModel(workoutObject: $0) }

        items.accept(newItems)
    }
    
    func onTapRegister(target: String, workoutName: String, weight: String, reps: String, memo: String) {
        var workout = WorkoutObject()
        workout.doneAt = DateUtils.toStringFromDate(date: dateRelay.value)
        workout.targetPart = target
        workout.workoutName = workoutName
        workout.weight = Double(weight)!
        workout.reps = Int(reps)!
        workout.volume = Double(Double(weight)! * Double(reps)!)
        workout.memo = memo
        
        model.saveWorkout(with: workout)
        updateItems()
    }
    
    func onDeleteRow(row: Int) {
        let item = items.value[row]
        model.deleteWorkout(with: item.workoutObject)

        updateItems()
    }
    
    func returnItem(row: Int) -> WorkoutRecordCellViewModel {
        let item = items.value[row]
        return item
    }
    
    func dateUpdate(date: Date) {
        dateRelay.accept(date)
        
        updateItems()
    }
    
    func onEditItem(target: String, workoutName: String, weight: String, reps: String, memo: String, row: Int) {
        var newWorkout = WorkoutObject()
        newWorkout.doneAt = DateUtils.toStringFromDate(date: dateRelay.value)
        newWorkout.targetPart = target
        newWorkout.workoutName = workoutName
        newWorkout.weight = Double(weight)!
        newWorkout.reps = Int(reps)!
        newWorkout.volume = Double(Double(weight)! * Double(reps)!)
        newWorkout.memo = memo
        
        let workout = items.value[row].workoutObject

        model.updateWorkout(from: workout, to: newWorkout)
        updateItems()
    }
    
    func returnItemsAndVolume(target: String, addstring: String) -> Double {
        let targetString = String(target.prefix(target.count - addstring.count))
        let workoutArray: [WorkoutObject]
        
        if targetString == "すべて" {
            workoutArray = model.getWorkout(doneAtDate: dateRelay.value)
        } else {
            workoutArray = model.getWorkout(doneAtDate: dateRelay.value).filter { $0.targetPart == targetString }
        }
        
        let result = workoutArray.map { $0.volume }.reduce(0, +)
        let sortedWorkoutArray = sortItems(workoutArray: workoutArray)
        let itemArray = sortedWorkoutArray.map { WorkoutRecordCellViewModel(workoutObject: $0)}
        items.accept(itemArray)
        return result
    }
    
    func sortItems(workoutArray: [WorkoutObject]) -> [WorkoutObject] {
        let targetMenuArray = menuArray.map { $0.targetPart }
        
        let workoutArray = workoutArray.sorted { lhs, rhs in
            if lhs.targetPart == rhs.targetPart {
                let workoutNamesArray = menuArray[targetMenuArray.firstIndex(of: lhs.targetPart)!]
                    .workoutNames.map { $0.workoutName }
                return workoutNamesArray.firstIndex(of: lhs.workoutName)! < workoutNamesArray.firstIndex(of: rhs.workoutName)!
            } else {
                return targetMenuArray.firstIndex(of: lhs.targetPart)! < targetMenuArray.firstIndex(of: rhs.targetPart)!
            }
        }
        return workoutArray
    }
}
