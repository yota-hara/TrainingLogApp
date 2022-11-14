//
//  WorkoutViewModel.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/02.
//

import RxSwift
import RxRelay

class WorkoutRecordViewModel {
    var doneAtDate: Date = Date()
    private let dateRelay = BehaviorRelay<Date>(value: Date())
    var currentDate: Observable<Date> {
        return dateRelay.share().asObservable()
    }
    
    private let disposeBag = DisposeBag()
    
    var workoutCellViewModels = [WorkoutRecordCellViewModel]()
    var workoutCellViewModelsRelay: BehaviorRelay<[WorkoutRecordCellViewModel]>?
    let model = RealmModel()
    
    init() {
        workoutCellViewModelsRelay = BehaviorRelay<[WorkoutRecordCellViewModel]>(value: workoutCellViewModels)
      
        let workoutArray = model.getWorkout(doneAtDate: doneAtDate).map { WorkoutRecordCellViewModel(workoutObject: $0)}
        workoutCellViewModelsRelay!.accept(workoutArray)
    }
    
    func onTapRegister(target: String, workoutName: String, weight: String, reps: String, memo: String) {
        var workout = WorkoutObject()
        workout.doneAt = DateUtils.toStringFromDate(date: doneAtDate)
        workout.targetPart = target
        workout.workoutName = workoutName
        workout.weight = Double(weight)!
        workout.reps = Int(reps)!
        workout.volume = Double(Double(weight)! * Double(reps)!)
        workout.memo = memo
        
        let workoutCellViewModel = WorkoutRecordCellViewModel(workoutObject: workout)
        workoutCellViewModelsRelay!.accept([workoutCellViewModel])
        model.saveWorkout(with: workout)
        
        dateUpdate(date: doneAtDate)
    }

    func viewDidLoad(){
        let workoutArray = model.getWorkout(doneAtDate: doneAtDate).map { WorkoutRecordCellViewModel(workoutObject: $0)}
        workoutCellViewModelsRelay!.accept(workoutArray)
    }
    
    func dateUpdate(date: Date) {
        self.doneAtDate = date
        dateRelay.accept(date)
        
        let workoutArray = model.getWorkout(doneAtDate: doneAtDate).map { WorkoutRecordCellViewModel(workoutObject: $0)}
        workoutCellViewModelsRelay!.accept(workoutArray)
    }
}

