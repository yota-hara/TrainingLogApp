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
  
    private var parentVC: BaseViewController?
    private let disposeBag = DisposeBag()
    private let workoutRecordTableViewDataSource = WorkoutRecordTableViewDataSource()
    private var recordViewModel: WorkoutRecordViewModel?
    private var dateSelectView: DateSelectView?
    private var editCellView: EditCellView?
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
    
    init(parent: BaseViewController, recordViewModel: WorkoutRecordViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.parentVC = parent
        self.recordViewModel = recordViewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let dateSelectViewHeight: CGFloat = view.safeAreaInsets.top + 50
        
        dateSelectView?.frame = CGRect(x: 0,
                                       y: 0,
                                       width: view.frame.size.width,
                                       height: dateSelectViewHeight)
        
        workoutTableView.frame = CGRect(x: 0,
                                        y: (dateSelectView?.frame.maxY)!,
                                        width: view.frame.size.width,
                                        height: view.frame.size.height)
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
            if self?.parentVC?.recordForm?.alpha != 0 {
                return
            } else {
                
                let dateString = self?.dateSelectView?.dateLabel?.text
                let date = DateUtils.toDateFromString(string: dateString!)
                let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                self?.recordViewModel?.dateUpdate(date: newDate)
            }
        }).disposed(by: disposeBag)
        
        dateSelectView?.prevButton?.rx.tap.asDriver().drive(onNext: { [weak self] in
            if self?.parentVC?.recordForm?.alpha != 0 {
                return
            } else {
            
            let dateString = self?.dateSelectView?.dateLabel?.text
            let date = DateUtils.toDateFromString(string: dateString!)
            let newDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            self?.recordViewModel?.dateUpdate(date: newDate)
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate

extension WorkoutRecordController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // TODO: - cellの編集内容のrealm書き換え処理の実装、editView表示時の他のViewの操作禁止設定
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
        
        let editAction = UIContextualAction(style: .normal, title: "編集") { [weak self] action, view, completionHandler in
            
            if self?.parentVC?.recordForm?.alpha != 0 {
                
                return
                
            } else {
                
                self?.parentVC?.footer?.isUserInteractionEnabled = false
                self?.workoutTableView.isUserInteractionEnabled = false
                self?.dateSelectView!.isUserInteractionEnabled = false

                let item = self?.recordViewModel?.returnItem(row: indexPath.row)
                let width: CGFloat = (self?.view.frame.size.width)! - 40
                let height: CGFloat = 400
                
                self?.editCellView = EditCellView(frame: CGRect(x: (self?.parentVC?.view.center.x)! - width / 2,
                                                          y: (self?.parentVC?.view.center.y)! - height / 2,
                                                          width: width,
                                                          height: height),
                                            item: item!)
                self?.view.addSubview((self?.editCellView!)!)
                let readytransform = CGAffineTransform(scaleX: 0, y: 0)
                    UIView.animate(withDuration: 0, animations: {
                        self?.editCellView!.transform = readytransform
                    })
                let transform = CGAffineTransform(scaleX: 1, y: 1)
                UIView.animate(withDuration: 0.5, animations: {
                        self?.editCellView!.transform = transform
                    })
                
                self?.editCellView?.editButton?.rx.tap.asDriver().drive(onNext: { [weak self] in
                    
                    let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    UIView.animate(withDuration: 0.5, animations: {
                        self?.editCellView!.transform = transform
                        self?.editCellView!.alpha = 0
                    }) { _ in
                        self?.editCellView?.isHidden = true
                        self?.parentVC?.footer?.isUserInteractionEnabled = true
                        self?.workoutTableView.isUserInteractionEnabled = true
                        self?.dateSelectView!.isUserInteractionEnabled = true
                    }
                }).disposed(by: (self?.disposeBag)!)
                
                self?.editCellView?.cancelButton?.rx.tap.asDriver().drive(onNext: { [weak self] in
                    
                    let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    UIView.animate(withDuration: 0.5, animations: {
                        self?.editCellView!.transform = transform
                        self?.editCellView!.alpha = 0
                    }) { _ in
                        self?.editCellView?.isHidden = true
                        self?.parentVC?.footer?.isUserInteractionEnabled = true
                        self?.workoutTableView.isUserInteractionEnabled = true
                        self?.dateSelectView!.isUserInteractionEnabled = true
                    }
                }).disposed(by: (self?.disposeBag)!)
            }
        }
        editAction.backgroundColor = .green
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
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

