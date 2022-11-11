//
//  RecordWorkoutController.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit
import RxSwift
import RxCocoa
import FSCalendar

class WorkoutRecordController: UIViewController {
    
    // MARK: - Properties & UIParts
    
    private var recordViewModel: WorkoutRecordViewModel?
    private let disposeBag = DisposeBag()
    
    private let workoutTableView: UITableView = {
        let table = UITableView()
        table.register(WorkoutRecordCell.self, forCellReuseIdentifier: WorkoutRecordCell.identifier)
       return table
    }()
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        recordViewModel = WorkoutRecordViewModel()

        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        workoutTableView.frame = CGRect(x: 0,
                                        y: 0,
                                        width: view.frame.size.width,
                                        height: view.frame.size.height)
    }
    
    private func setupTableView() {
        view.addSubview(workoutTableView)
        workoutTableView.delegate = self
        
        recordViewModel?.viewDidLoad()
        
        recordViewModel?.workoutCellViewModels
            .bind(to: workoutTableView.rx.items(cellIdentifier: WorkoutRecordCell.identifier,
                                                cellType: WorkoutRecordCell.self)) { row, cellViewModel, cell in
                cell.configure(viewModel: cellViewModel)
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension WorkoutRecordController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

}
