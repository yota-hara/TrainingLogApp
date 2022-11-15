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
        
        let item = WorkoutRecordCellViewModel(workoutObject: workout)
        items.accept([item])
        model.saveWorkout(with: workout)
        
        dateUpdate(date: dateRelay.value)
    }
    
    func onDeleteRow(row: Int) {
        let item = items.value[row]
        model.deleteWorkout(with: item.workoutObject)
        items.remove(index: row)
    }

    func viewDidLoad(){
        let workoutArray = model.getWorkout(doneAtDate: dateRelay.value).map { WorkoutRecordCellViewModel(workoutObject: $0)}
        items.accept(workoutArray)
    }
    
    func dateUpdate(date: Date) {
        dateRelay.accept(date)
        
        let workoutArray = model.getWorkout(doneAtDate: dateRelay.value).map { WorkoutRecordCellViewModel(workoutObject: $0)}
        items.accept(workoutArray)
    }
}

