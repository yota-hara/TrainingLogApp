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

class WorkoutRecordViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties & UIParts
  
    private var parentVC: parentViewControllerPresentable?
    private let disposeBag = DisposeBag()
    private var selectTarget = 0
    private let workoutRecordTableViewDataSource = WorkoutRecordTableViewDataSource()
    
    private var validationViewModel: FormValidateViewModel?
    private var recordViewModel: WorkoutRecordViewModel?
    private var menuViewModel: WorkoutMenuViewModel?
    
    private var totalVolumeView: TotalVolumeView?
    private var dateSelectView: DateSelectView?
    private var editCellView: EditCellView?
    private var workoutTableView: UITableView?
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        workoutTableView = createTableView()
        menuViewModel = WorkoutMenuViewModel()
        setupTableView()
        setupDateSelectView()
        setupRecordViewModel()

        totalVolumeView = TotalVolumeView(frame: .zero,
                                          menuViewModel: menuViewModel!,
                                          recordViewModel: recordViewModel!)
        view.addSubview(totalVolumeView!)
    }
    
    init(parent: parentViewControllerPresentable, recordViewModel: WorkoutRecordViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.parentVC = parent
        self.recordViewModel = recordViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createEditView(row: Int) -> EditCellView {
        let width: CGFloat = view.frame.size.width - 40
        let height: CGFloat = 400
        
        let editView = EditCellView(frame: CGRect(x: (parentVC?.parentCenter?.x)! - width / 2,
                                                  y: (parentVC?.parentCenter?.y)! - height / 2,
                                                  width: width,
                                                  height: height),
                                    row: row,
                                    recordViewModel: recordViewModel!,
                                    menuViewModel: menuViewModel!)
        view.addSubview(editView)
        return editView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let dateSelectViewHeight: CGFloat = view.safeAreaInsets.top + 50
        
        dateSelectView?.frame = CGRect(x: 0,
                                       y: 0,
                                       width: view.frame.size.width,
                                       height: dateSelectViewHeight)
        
        totalVolumeView?.frame = CGRect(x: 0,
                                        y: dateSelectViewHeight,
                                        width: view.frame.size.width,
                                        height: 30)
        
        workoutTableView?.frame = CGRect(x: 0,
                                        y: (totalVolumeView?.frame.maxY)!,
                                        width: view.frame.size.width,
                                        height: view.frame.size.height - (totalVolumeView?.frame.maxY)!)
        

    }
    
    private func setupKeyboardAndView() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
                    .subscribe({ notification in
                        if let element = notification.element {
                            self.keyboardwillShow(element)
                        }
                    })
                    .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
                    .subscribe({ notification in
                        if let element = notification.element {
                            self.keyboardWillHide(element)
                        }
                    })
                    .disposed(by: disposeBag)
    }
    
    private func keyboardwillShow(_ notification: Notification) {
        guard let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
            UIView.animate(withDuration: duration) {
                let transform = CGAffineTransform(translationX: 0,
                                                  y:  -rect.size.height + 200)
                self.view.transform = transform
        }
    }
    
    private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    func createTableView() -> UITableView {
        let table = UITableView()
        table.register(WorkoutRecordCell.self, forCellReuseIdentifier: WorkoutRecordCell.identifier)
        return table
    }
    
    private func setupTableView() {
        view.addSubview(workoutTableView!)
        workoutTableView?.delegate = self

    }
    
    private func setupRecordViewModel() {
        recordViewModel?.updateItems()
        
        recordViewModel?.itemObservable
            .bind(to: (workoutTableView?.rx.items(dataSource: workoutRecordTableViewDataSource))!)
            .disposed(by: disposeBag)
        
        recordViewModel?.editCellViewAperr.asDriver().drive(onNext: { [weak self] apear in
            self?.parentVC?.footer?.isUserInteractionEnabled = !apear
            self?.workoutTableView?.isUserInteractionEnabled = !apear
            self?.dateSelectView?.isUserInteractionEnabled = !apear
        }).disposed(by: disposeBag)
        
        recordViewModel?.updateItems()
    }
    
    private func setupDateSelectView() {
        dateSelectView = DateSelectView(frame: .zero, recordViewModel: recordViewModel!)
        
        recordViewModel?.currentDate.asDriver(onErrorJustReturn: Date()).drive(onNext: { date in
            self.dateSelectView?.dateTextField?.text = DateUtils.toStringFromDate(date: date)
        }).disposed(by: disposeBag)
        
        view.addSubview(dateSelectView!)
    }
    

}

// MARK: - UITableViewDelegate

extension WorkoutRecordViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "削除") {action, view, completionHandler in
            
            let alert = UIAlertController(title: "確認", message: "選択中のデータを削除しますか?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { _ in
                self.recordViewModel?.onDeleteRow(row: indexPath.row)
            }))
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            completionHandler(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "編集") { [weak self] action, view, completionHandler in

            self?.editCellView = self?.createEditView(row: indexPath.row)
            
            self?.recordViewModel?.editCellViewAperr.accept(true)
        }
        editAction.backgroundColor = .green
        
        var config: UISwipeActionsConfiguration?
        
        // recordFormの出現時にはスワイプアクションを許可しない
        recordViewModel!.recordFormApear.asDriver().drive(onNext: { apear in
            if apear {
               config = UISwipeActionsConfiguration(actions: [])
            } else {
                config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            }

        }).disposed(by: disposeBag)

        return config
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
