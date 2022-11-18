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
    private let workoutTableView: UITableView = {
        let table = UITableView()
        table.register(WorkoutRecordCell.self, forCellReuseIdentifier: WorkoutRecordCell.identifier)
       return table
    }()
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        workoutTableView.frame = CGRect(x: 0,
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
    
    private func setupTableView() {
        view.addSubview(workoutTableView)
        workoutTableView.delegate = self

    }
    
    private func setupRecordViewModel() {
        recordViewModel?.updateItems()
        
        recordViewModel?.itemObservable
            .bind(to: workoutTableView.rx.items(dataSource: workoutRecordTableViewDataSource))
            .disposed(by: disposeBag)
        
        recordViewModel?.updateItems()
    }
    
    private func setupDateSelectView() {
        dateSelectView = DateSelectView(frame: .zero, recordViewModel: recordViewModel!)
        
        recordViewModel?.currentDate.asDriver(onErrorJustReturn: Date()).drive(onNext: { date in
            self.dateSelectView?.dateTextField?.text = DateUtils.toStringFromDate(date: date)
        }).disposed(by: disposeBag)
        
        view.addSubview(dateSelectView!)
    }
    
    private func editWorkout(row: Int) {
        let target = editCellView?.targetPartTextField?.textField?.text
        let workoutName = editCellView?.workoutNameTextField?.textField?.text
        let weight = editCellView?.weightTextField?.textField?.text
        let reps = editCellView?.repsTextField?.textField?.text
        let memo = editCellView?.memoTextView?.textView?.text
        
        recordViewModel?.onEditItem(target: target!,
                                    workoutName: workoutName!,
                                    weight: weight!,
                                    reps: reps!,
                                    memo: memo!,
                                    row: row)
    }
    
    private func setupEditCellView(row: Int) {
        validationViewModel = FormValidateViewModel()
        
        let item = recordViewModel?.returnItem(row: row)
        let width: CGFloat = view.frame.size.width - 40
        let height: CGFloat = 400
        
        editCellView = EditCellView(frame: CGRect(x: (parentVC?.parentCenter?.x)! - width / 2,
                                                  y: (parentVC?.parentCenter?.y)! - height / 2,
                                                  width: width,
                                                  height: height),
                                    item: item!)
        view.addSubview(editCellView!)
        setupTextFields()
        
        editCellView?.targetPartTextField?.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.validationViewModel?.targetTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        editCellView?.workoutNameTextField?.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.validationViewModel?.workoutTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        editCellView?.weightTextField?.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.validationViewModel?.weightTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        editCellView?.repsTextField?.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.validationViewModel?.repsTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        validationViewModel?.validRegisterDriver.drive(onNext: { validAll in
            self.editCellView?.editButton?.isEnabled = validAll
            self.editCellView?.editButton?.layer.backgroundColor = validAll ? UIColor.orange.cgColor : UIColor.gray.cgColor
        }).disposed(by: disposeBag)

                
        let readytransform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0, animations: {
            self.editCellView!.transform = readytransform
        })
        let transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.animate(withDuration: 0.5, animations: {
            self.editCellView!.transform = transform
        })
        
        // editButton Action
        editCellView?.editButton?.rx.tap.asDriver().drive(onNext: { [weak self] in
            
            self?.editWorkout(row: row)
            
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
        }).disposed(by: disposeBag)
        
        // cancelButton Action
        editCellView?.cancelButton?.rx.tap.asDriver().drive(onNext: { [weak self] in
            
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
        }).disposed(by: disposeBag)
    }
    
    private func setupTextFields() {
        // targetPartTextField
        let targetPartPicker = UIPickerView()
        targetPartPicker.tag = 1
        targetPartPicker.delegate = self
        targetPartPicker.dataSource = self
        editCellView?.targetPartTextField?.textField!.inputView = targetPartPicker
        let targetPartToolbar = UIToolbar()
        targetPartToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        let targetSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let targetDoneButtonItem = UIBarButtonItem(title: "次へ",
                                                   style: .done,
                                                   target: self,
                                                   action: #selector(targetDonePicker))
        targetPartToolbar.setItems([targetSpace, targetDoneButtonItem], animated: true)
        editCellView?.targetPartTextField?.textField!.inputAccessoryView = targetPartToolbar
        editCellView?.targetPartTextField?.textField!.delegate = self
        
        // workoutNameTextField
        let workoutNamePicker = UIPickerView()
        workoutNamePicker.tag = 2
        workoutNamePicker.delegate = self
        workoutNamePicker.dataSource = self
        editCellView?.workoutNameTextField?.textField!.inputView = workoutNamePicker
        let workoutNameToolbar = UIToolbar()
        workoutNameToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        let workoutNameSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let workoutNameDoneButtonItem = UIBarButtonItem(title: "次へ",
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(workoutNameDonePicker))
        workoutNameToolbar.setItems([workoutNameSpace, workoutNameDoneButtonItem], animated: true)
        editCellView?.workoutNameTextField?.textField!.inputAccessoryView = workoutNameToolbar
        editCellView?.workoutNameTextField?.textField!.delegate = self
        
        // weightTextField
        editCellView?.weightTextField?.textField!.keyboardType = .decimalPad
        let weightToolbar = UIToolbar()
        weightToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        let weightSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let weightDoneButtonItem = UIBarButtonItem(title: "次へ",
                                                   style: .done,
                                                   target: self,
                                                   action: #selector(weightDonePicker))
        weightToolbar.setItems([weightSpace, weightDoneButtonItem], animated: true)
        editCellView?.weightTextField?.textField!.inputAccessoryView = weightToolbar
        editCellView?.weightTextField?.textField!.delegate = self
        
        // repsTextField
        editCellView?.repsTextField?.textField!.keyboardType = .numberPad
        let repsToolbar = UIToolbar()
        repsToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        let repsSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let repsDoneButtonItem = UIBarButtonItem(title: "次へ",
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(repsDonePicker))
        repsToolbar.setItems([repsSpace, repsDoneButtonItem], animated: true)
        editCellView?.repsTextField?.textField!.inputAccessoryView = repsToolbar
        editCellView?.repsTextField?.textField!.delegate = self
        
        //memoTextView
        editCellView?.memoTextView?.textView!.keyboardType = .default
        let memoToolbar = UIToolbar()
        memoToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        let space5 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem5 = UIBarButtonItem(title: "OK",
                                              style: .done,
                                              target: self,
                                              action: #selector(memoDonePicker))
        memoToolbar.setItems([space5, doneButtonItem5], animated: true)
        editCellView?.memoTextView?.textView!.inputAccessoryView = memoToolbar

    }
    
    @objc func targetDonePicker() {
        editCellView?.workoutNameTextField?.textField!.becomeFirstResponder()
    }
    @objc func workoutNameDonePicker() {
        editCellView?.weightTextField?.textField!.becomeFirstResponder()
    }
    @objc func weightDonePicker() {
        editCellView?.repsTextField?.textField!.becomeFirstResponder()
    }
    @objc func repsDonePicker() {
        editCellView?.memoTextView?.textView!.becomeFirstResponder()
    }
    @objc func memoDonePicker() {
        editCellView?.memoTextView?.textView!.resignFirstResponder()
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
                
                self?.parentVC?.footer?.isUserInteractionEnabled = false
                self?.workoutTableView.isUserInteractionEnabled = false
                self?.dateSelectView!.isUserInteractionEnabled = false
                self?.setupEditCellView(row: indexPath.row)
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

// MARK: - UIPickerView

extension WorkoutRecordViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 1: return (menuViewModel?.workoutMenuArray.count)!
        case 2: return (menuViewModel?.workoutMenuArray[selectTarget].workoutNames.count)!
        default: fatalError()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            selectTarget = row
            return menuViewModel?.workoutMenuArray[row].targetPart
        case 2:
            return menuViewModel?.workoutMenuArray[selectTarget].workoutNames[row].workoutName
        default: fatalError()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            editCellView?.targetPartTextField?.textField!.text = menuViewModel?
                .workoutMenuArray[row].targetPart
            
            if editCellView?.targetPartTextField?.textField!.text == nil {
                editCellView?.targetPartTextField?.textField!.text = menuViewModel?
                    .workoutMenuArray[0].targetPart
            }
        case 2:
            editCellView?.workoutNameTextField?.textField!.text = menuViewModel?
                .workoutMenuArray[selectTarget].workoutNames[row].workoutName
            
            if editCellView?.targetPartTextField?.textField!.text == nil {
                editCellView?.targetPartTextField?.textField!.text = menuViewModel?
                    .workoutMenuArray[selectTarget].workoutNames[0].workoutName
            }
        default: fatalError()
        }
    }
}

