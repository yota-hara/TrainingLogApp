//
//  ViewController.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/10/31.
//

import UIKit
import RxSwift
import RxCocoa
import FSCalendar

protocol ViewControllerDelegate {

}

class HomeViewController: UIViewController, ViewControllerDelegate, UITextFieldDelegate {
    var recordForm: RecordFormView?
    
    
    // MARK: - Properties & UIParts
    
    private var selectTarget = 0
    
    var footer: PublicFooterView?
    var viewModel: FormValidateViewModel?
    var workoutMenuViewModel: WorkoutMenuViewModel?
    var calender: FSCalendar!
    private let disposeBag = DisposeBag()
    
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        workoutMenuViewModel = WorkoutMenuViewModel()

        setUpCalender()
        view.addSubview(calender)
        
        viewModel = FormValidateViewModel()
        
        footerBind()
        recordFormBind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calender.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.frame.width, height: 300)
        footer?.anchor(bottom: view.bottomAnchor, left: view.leftAnchor, width: view.frame.size.width, height: 100)
        recordForm?.anchor(top: view.topAnchor, centerX: view.centerXAnchor, width: view.frame.size.width-40, height: 400, topPadding: 100)
    }
    
    // MARK: - Bindings
    
    func recordFormBind() {
        recordForm = RecordFormView()
        recordForm?.alpha = 0
        view.addSubview(recordForm!)
        setupTextFields()
        
        recordForm?.targetPartTextField.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.viewModel?.targetTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        recordForm?.workoutNameTextField.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.viewModel?.workoutTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        recordForm?.weightTextField.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.viewModel?.weightTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        recordForm?.repsTextField.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.viewModel?.repsTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        viewModel?.validRegisterDriver.drive(onNext: { validAll in
            self.recordForm?.registerButton.isEnabled = validAll
            self.recordForm?.registerButton.layer.backgroundColor = validAll ? UIColor.orange.cgColor : UIColor.gray.cgColor
        }).disposed(by: disposeBag)

        recordForm?.registerButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            print("buttonTapped")
        }).disposed(by: disposeBag)
    }
    
    
    func footerBind() {
        footer = PublicFooterView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 100))
        view.addSubview(footer!)
        footer?.addWorkoutButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            switch self?.recordForm?.alpha {
            case 0:
                UIView.animate(withDuration: 0.7, delay: 0.1, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self?.recordForm?.alpha = 1
                })
                self?.footer?.addWorkoutButton.setImage(UIImage(systemName: "multiply"), for: .normal)
                self?.footer?.addWorkoutButton.backgroundColor = .systemMint
            case 1:
                UIView.animate(withDuration: 0.7, delay: 0.1, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self?.recordForm?.alpha = 0
                })
                self?.footer?.addWorkoutButton.setImage(UIImage(systemName: "plus"), for: .normal)
                self?.footer?.addWorkoutButton.backgroundColor = .orange
            case .none:
                break
            case .some(_):
                break
            }
        }).disposed(by: disposeBag)
        
        footer?.homeButton.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let homeVC = HomeViewController()
            homeVC.modalPresentationStyle = .fullScreen
            homeVC.modalTransitionStyle = .crossDissolve
            self?.present(homeVC, animated: true)
        }).disposed(by: disposeBag)
        
        footer?.recordWorkoutButton.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let recordVC = RecordWorkoutController()
            recordVC.modalPresentationStyle = .fullScreen
            recordVC.modalTransitionStyle = .crossDissolve
            self?.present(recordVC, animated: true)
        }).disposed(by: disposeBag)
        
        footer?.registerMenuButton.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let registerVC = RegisterMenuController()
            registerVC.modalPresentationStyle = .fullScreen
            registerVC.modalTransitionStyle = .crossDissolve
            self?.present(registerVC, animated: true)
        }).disposed(by: disposeBag)
        
        footer?.settingsButton.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let settingVC = SettingViewController()
            settingVC.modalPresentationStyle = .fullScreen
            settingVC.modalTransitionStyle = .crossDissolve
            self?.present(settingVC, animated: true)
        }).disposed(by: disposeBag)
    }
    
    func setUpCalender() {
        calender = FSCalendar()
        calender.scrollDirection = .horizontal
        calender.scope = .month
        
        calender.appearance.titleFont = UIFont.systemFont(ofSize: 14)
        calender.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 18)
        calender.appearance.headerDateFormat = "yyyy年MM月"
        calender.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 16)
        
        calender.appearance.todayColor = .systemMint
        calender.appearance.titleTodayColor = .white
        calender.appearance.headerTitleColor = .black
        calender.appearance.weekdayTextColor = .blue
        calender.appearance.titleWeekendColor = .red
        calender.appearance.titleDefaultColor = .black
        calender.delegate = self
        calender.dataSource = self
    }
    
    // MARK: - setupTextFields
    private func setupTextFields() {
        // targetPartTextField
        let targetPartPicker = UIPickerView()
        targetPartPicker.tag = 1
        targetPartPicker.delegate = self
        targetPartPicker.dataSource = self
        recordForm?.targetPartTextField.textField!.inputView = targetPartPicker
        let targetPartToolbar = UIToolbar()
        targetPartToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        let space1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem1 = UIBarButtonItem(title: "次へ", style: .done, target: self, action: #selector(donePicker1))
        targetPartToolbar.setItems([space1, doneButtonItem1], animated: true)
        recordForm?.targetPartTextField.textField!.inputAccessoryView = targetPartToolbar
        recordForm?.targetPartTextField.textField!.delegate = self
        
        // workoutNameTextField
        let workoutNamePicker = UIPickerView()
        workoutNamePicker.tag = 2
        workoutNamePicker.delegate = self
        workoutNamePicker.dataSource = self
        recordForm?.workoutNameTextField.textField!.inputView = workoutNamePicker
        let workoutNameToolbar = UIToolbar()
        workoutNameToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        let space2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem2 = UIBarButtonItem(title: "次へ", style: .done, target: self, action: #selector(donePicker2))
        workoutNameToolbar.setItems([space2, doneButtonItem2], animated: true)
        recordForm?.workoutNameTextField.textField!.inputAccessoryView = workoutNameToolbar
        recordForm?.workoutNameTextField.textField!.delegate = self
        
        // weightTextField
        recordForm?.weightTextField.textField!.keyboardType = .decimalPad
        let weightToolbar = UIToolbar()
        weightToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        let space3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem3 = UIBarButtonItem(title: "次へ", style: .done, target: self, action: #selector(donePicker3))
        weightToolbar.setItems([space3, doneButtonItem3], animated: true)
        recordForm?.weightTextField.textField!.inputAccessoryView = weightToolbar
        recordForm?.weightTextField.textField!.delegate = self
        
        // repsTextField
        recordForm?.repsTextField.textField!.keyboardType = .numberPad
        let repsToolbar = UIToolbar()
        repsToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        let space4 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem4 = UIBarButtonItem(title: "次へ", style: .done, target: self, action: #selector(donePicker4))
        repsToolbar.setItems([space4, doneButtonItem4], animated: true)
        recordForm?.repsTextField.textField!.inputAccessoryView = repsToolbar
        recordForm?.repsTextField.textField!.delegate = self
        
        //memoTextView
        recordForm?.memoTextView.textView!.keyboardType = .default
        let memoToolbar = UIToolbar()
        memoToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        let space5 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem5 = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(donePicker5))
        memoToolbar.setItems([space5, doneButtonItem5], animated: true)
        recordForm?.memoTextView.textView!.inputAccessoryView = memoToolbar

    }
    
    @objc func donePicker1() {
        recordForm?.workoutNameTextField.textField!.becomeFirstResponder()
    }
    @objc func donePicker2() {
        recordForm?.weightTextField.textField!.becomeFirstResponder()
    }
    @objc func donePicker3() {
        recordForm?.repsTextField.textField!.becomeFirstResponder()
    }
    @objc func donePicker4() {
        recordForm?.memoTextView.textView!.becomeFirstResponder()
    }
    @objc func donePicker5() {
        recordForm?.memoTextView.textView!.resignFirstResponder()
    }
    
    //MARK: - UITextFieldDelegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: - UIPickerView
extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 1: return (workoutMenuViewModel?.workoutMenuArray.count)!
        case 2: return (workoutMenuViewModel?.workoutMenuArray[selectTarget].workoutNames.count)!
        default: fatalError()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            selectTarget = row
            return workoutMenuViewModel?.workoutMenuArray[row].targetPart
        case 2:
            return workoutMenuViewModel?.workoutMenuArray[selectTarget].workoutNames[row].workoutName
        default: fatalError()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            recordForm?.targetPartTextField.textField!.text = workoutMenuViewModel?
                .workoutMenuArray[row].targetPart
            
            if recordForm?.targetPartTextField.textField!.text == nil {
                recordForm?.targetPartTextField.textField!.text = workoutMenuViewModel?
                    .workoutMenuArray[0].targetPart
            }
        case 2:
            recordForm?.workoutNameTextField.textField!.text = workoutMenuViewModel?
                .workoutMenuArray[selectTarget].workoutNames[row].workoutName
            
            if recordForm?.targetPartTextField.textField!.text == nil {
                recordForm?.targetPartTextField.textField!.text = workoutMenuViewModel?
                    .workoutMenuArray[selectTarget].workoutNames[0].workoutName
            }
        default: fatalError()
        }
    }
}

// MARK: - FSCalendar
extension HomeViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print("Date Selected == \(formatter.string(from: date))")
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print("Date De-Selected == \(formatter.string(from: date))")
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 0
    }
}

