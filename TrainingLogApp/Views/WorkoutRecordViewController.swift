//
//  RecordWorkoutController.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit
import RxSwift
import RxCocoa

class WorkoutRecordController: UIViewController {
    
    // MARK: - Properties & UIParts
    
    var menuViewModel: WorkoutMenuViewModel?
    var workoutViewModel: WorkoutRecordViewModel?
    private let disposeBag = DisposeBag()
    
    let workoutTableView: UITableView = {
        let table = UITableView()
        table.register(WorkoutRecordCell.self, forCellReuseIdentifier: WorkoutRecordCell.identifier)
       return table
    }()
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        menuViewModel = WorkoutMenuViewModel()
        workoutViewModel = WorkoutRecordViewModel()
        
        view.addSubview(workoutTableView)
        workoutTableView.delegate = self
        
        workoutViewModel?.viewDidLoad()
        workoutBind()
        workoutTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        workoutTableView.frame = view.frame
    }
    
    func workoutBind() {
        workoutViewModel?.workoutCellViewModels
            .bind(to: workoutTableView.rx.items(cellIdentifier: WorkoutRecordCell.identifier,
                                                cellType: WorkoutRecordCell.self)) { row, cellViewModel, cell in
                cell.configure(viewModel: cellViewModel)
            }.disposed(by: disposeBag)
    }
}

extension WorkoutRecordController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

}
