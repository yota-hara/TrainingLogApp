//
//  RecordWorkoutController.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit
import RxSwift
import RxCocoa

class RecordWorkoutController: UIViewController {
    
    // MARK: - Properties & UIParts
    
    var menuViewModel: WorkoutMenuViewModel?
    var workoutViewModel: WorkoutViewModel?
    private let disposeBag = DisposeBag()
    
    let workoutTableView: UITableView = {
        let table = UITableView()
        table.register(WorkoutCell.self, forCellReuseIdentifier: WorkoutCell.identifier)
       return table
    }()
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        menuViewModel = WorkoutMenuViewModel()
        workoutViewModel = WorkoutViewModel()
        
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
            .bind(to: workoutTableView.rx.items(cellIdentifier: WorkoutCell.identifier,
                                                cellType: WorkoutCell.self)) { row, cellViewModel, cell in
                cell.configure(viewModel: cellViewModel, row: row)
            }.disposed(by: disposeBag)
    }
}

extension RecordWorkoutController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

}
