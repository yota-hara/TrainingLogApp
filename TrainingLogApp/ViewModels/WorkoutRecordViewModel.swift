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
    
    init() {
        updateItems()
    }
    
    func updateItems() {
        let workoutArray = model.getWorkout(doneAtDate: dateRelay.value).map { WorkoutRecordCellViewModel(workoutObject: $0)}
        items.accept(workoutArray)
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
        items.remove(index: row)
    }
    
    func returnItem(row: Int) -> WorkoutRecordCellViewModel {
        let item = items.value[row]
        return item
    }

    func viewDidLoad(){
        let workoutArray = model.getWorkout(doneAtDate: dateRelay.value)
            .map { WorkoutRecordCellViewModel(workoutObject: $0)}
        items.accept(workoutArray)
    }
    
    func dateUpdate(date: Date) {
        dateRelay.accept(date)
        
        let workoutArray = model.getWorkout(doneAtDate: dateRelay.value)
            .map { WorkoutRecordCellViewModel(workoutObject: $0)}
        items.accept(workoutArray)
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
        
//        items.value[row] = WorkoutRecordCellViewModel(workoutObject: newWorkout)
//        items.value.remove(at: row)
//        items.value.insert((WorkoutRecordCellViewModel(workoutObject: newWorkout), at: row)
        model.updateWorkout(from: workout, to: newWorkout)
        updateItems()
    }
}

