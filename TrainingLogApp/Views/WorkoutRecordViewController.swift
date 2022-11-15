//
//  RecordWorkoutController.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class WorkoutRecordController: UIViewController {
    
    // MARK: - Properties & UIParts
  
    private let disposeBag = DisposeBag()
    private let workoutRecordTableViewDataSource = WorkoutRecordTableViewDataSource()
    private var recordViewModel: WorkoutRecordViewModel?
    private var dateSelectView: DateSelectView?
    private let workoutTableView: UITableView = {
        let table = UITableView()
        table.register(WorkoutRecordCell.self, forCellReuseIdentifier: WorkoutRecordCell.identifier)
       return table
    }()
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()


        setupTableView()
        setupDateSelectView()
        setupRecordViewModel()
    }
    
    init(recordViewModel: WorkoutRecordViewModel) {
        super.init(nibName: nil, bundle: nil)
        
        self.recordViewModel = recordViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let dateSelectViewHeight: CGFloat = view.safeAreaInsets.top + 50
        
        dateSelectView?.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: dateSelectViewHeight)
        
        workoutTableView.frame = CGRect(x: 0,
                                        y: (dateSelectView?.frame.maxY)!,
                                        width: view.frame.size.width,
                                        height: view.frame.size.height)
    }
    
    private func setupTableView() {
        view.addSubview(workoutTableView)
        workoutTableView.delegate = self
        
        
        
        workoutTableView.rx.itemDeleted.asDriver().drive { [weak self] indexPath in
            self?.recordViewModel?.onDeleteRow(row: indexPath.row)
        }.disposed(by: disposeBag)
    }
    
    private func setupRecordViewModel() {
        recordViewModel?.viewDidLoad()
        
        recordViewModel?.itemObservable
            .bind(to: workoutTableView.rx.items(dataSource: workoutRecordTableViewDataSource))
            .disposed(by: disposeBag)
        
        recordViewModel?.updateItems()
    }
    
    private func setupDateSelectView() {
        dateSelectView = DateSelectView()
        
        view.addSubview(dateSelectView!)
        
        recordViewModel?.currentDate.asDriver(onErrorJustReturn: Date()).drive(onNext: { date in
            self.dateSelectView?.dateLabel?.text = DateUtils.toStringFromDate(date: date)
        }).disposed(by: disposeBag)
                
        dateSelectView!.nextButton?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let dateString = self?.dateSelectView?.dateLabel?.text
            let date = DateUtils.toDateFromString(string: dateString!)
            let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
            self?.recordViewModel?.dateUpdate(date: newDate)
//            self?.workoutTableView.reloadData()
        }).disposed(by: disposeBag)
        
        dateSelectView?.prevButton?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let dateString = self?.dateSelectView?.dateLabel?.text
            let date = DateUtils.toDateFromString(string: dateString!)
            let newDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            self?.recordViewModel?.dateUpdate(date: newDate)
//            self?.workoutTableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension WorkoutRecordController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // FIXME: dataSourceから削除されていない -

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "削除") {action, view, completionHandler in
            
            let alert = UIAlertController(title: "確認", message: "選択中のデータを削除しますか?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { _ in
                self.recordViewModel!.onDeleteRow(row: indexPath.row)
            }))
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            completionHandler(true)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}

// MARK: - WorkoutRecordTableViewDataSource

class WorkoutRecordTableViewDataSource: NSObject, UITableViewDataSource, RxTableViewDataSourceType {

    typealias Element = [WorkoutRecordCellViewModel]
    var items: Element = []

    func tableView(_ tableView: UITableView, observedEvent: Event<[WorkoutRecordCellViewModel]>) {
        Binder(self) { dataSource, element in
            dataSource.items = element
            tableView.reloadData()
        }
        .on(observedEvent)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WorkoutRecordCell.identifier, for: indexPath) as! WorkoutRecordCell
        cell.configure(viewModel: items[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

