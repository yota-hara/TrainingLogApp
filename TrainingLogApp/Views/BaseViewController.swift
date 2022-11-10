//
//  BaseViewController.swift
//  TrainingLogApp
//
//  Created by 田原葉 on 2022/11/09.
//


import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties & UIParts
    
    private var selectTarget = 0
    private var recordForm: RecordFormView?
    private var footer: PublicFooterView?
    private var validationviewModel: FormValidateViewModel?
    private var menuViewModel: WorkoutMenuViewModel?
    private var workoutViewModel: WorkoutViewModel?
    private let disposeBag = DisposeBag()
    private var vcView: UIView?
    private var childVC: UIViewController?
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuViewModel = WorkoutMenuViewModel()
        workoutViewModel = WorkoutViewModel()
        validationviewModel = FormValidateViewModel()

        setupChildVC()
        footerBind()
        recordFormBind()
        setupKeyboardAndView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        vcView!.anchor(top: view.topAnchor, bottom: footer?.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        footer?.anchor(bottom: view.bottomAnchor, left: view.leftAnchor, width: view.frame.size.width, height: 130)
        recordForm?.anchor(centerY: view.centerYAnchor, centerX: view.centerXAnchor, width: view.frame.size.width-40, height: 400)
    }
    
    // MARK: - Setup & Bindings
    
    private func setupChildVC() {
        vcView = UIView()
        
        let homeVC = HomeViewController()
        homeVC.view.frame = vcView!.frame
        addChild(homeVC)
        vcView?.addSubview(homeVC.view)
        homeVC.didMove(toParent: self)
        childVC = homeVC
        
        let recordWorkoutVC = RecordWorkoutController()
        recordWorkoutVC.view.frame = vcView!.frame

        let registerMenuVC = RegisterMenuController()
        registerMenuVC.view.frame = vcView!.frame
        
        let settingVC = SettingViewController()
        settingVC.view.frame = vcView!.frame
        
        view.addSubview(vcView!)
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
        if (self.recordForm?.memoTextView.textView?.frame.maxY)! < rect.minY {
            UIView.animate(withDuration: duration) {
                let transform = CGAffineTransform(translationX: 0,
                                                  y:  -rect.size.height + 200)
                self.view.transform = transform
            }
        }
    }
    
    private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    private func recordFormBind() {
        recordForm = RecordFormView()
        recordForm?.alpha = 0
        view.addSubview(recordForm!)
        setupTextFields()
        
        recordForm?.targetPartTextField.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.validationviewModel?.targetTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        recordForm?.workoutNameTextField.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.validationviewModel?.workoutTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        recordForm?.weightTextField.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.validationviewModel?.weightTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        recordForm?.repsTextField.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.validationviewModel?.repsTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        validationviewModel?.validRegisterDriver.drive(onNext: { validAll in
            self.recordForm?.registerButton.isEnabled = validAll
            self.recordForm?.registerButton.layer.backgroundColor = validAll ? UIColor.orange.cgColor : UIColor.gray.cgColor
        }).disposed(by: disposeBag)

        recordForm?.registerButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.registerWorkout()
            self?.RecordFormDisappear()
        }).disposed(by: disposeBag)
        
        recordForm?.clearButton.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.recordForm?.targetPartTextField.textField?.text = ""
            self?.recordForm?.workoutNameTextField.textField?.text = ""
            self?.recordForm?.weightTextField.textField?.text = ""
            self?.recordForm?.repsTextField.textField?.text = ""
            self?.recordForm?.memoTextView.textView?.text = ""
        }).disposed(by: disposeBag)
    }
    
    private func registerWorkout() {
        let target = recordForm?.targetPartTextField.textField?.text!
        let workoutName = recordForm?.workoutNameTextField.textField?.text!
        let weight = recordForm?.weightTextField.textField?.text!
        let reps = recordForm?.repsTextField.textField?.text!
        let memo = recordForm?.memoTextView.textView?.text!
        
        workoutViewModel?.onTapRegister(target: target!,
                                        workoutName: workoutName!,
                                        weight: weight!,
                                        reps: reps!,
                                        memo: memo!)
    }
    
    private func RecordFormDisappear() {
        UIView.animate(withDuration: 0.4, delay: 0.1, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            self.recordForm?.alpha = 0
            self.footer?.addWorkoutButton.setImage(UIImage(systemName: "plus"), for: .normal)
            self.footer?.addWorkoutButton.backgroundColor = .orange
        })
    }
    
    private func footerBind() {
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
            
            if self?.childVC != homeVC {
                self?.childVC!.willMove(toParent: nil)
                self?.childVC!.view.removeFromSuperview()
                self?.childVC!.removeFromParent()
                self?.addChild(homeVC)
                self?.vcView!.addSubview(homeVC.view)
                homeVC.didMove(toParent: self)
                self?.childVC = homeVC
                self?.RecordFormDisappear()
              }
        }).disposed(by: disposeBag)
        
        footer?.recordWorkoutButton.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let recordVC = RecordWorkoutController()
            if self?.childVC != recordVC {
                self?.childVC!.willMove(toParent: nil)
                self?.childVC!.view.removeFromSuperview()
                self?.childVC!.removeFromParent()
                self?.addChild(recordVC)
                self?.vcView!.addSubview(recordVC.view)
                recordVC.didMove(toParent: self)
                self?.childVC = recordVC
                self?.RecordFormDisappear()
              }
        }).disposed(by: disposeBag)
        
        footer?.registerMenuButton.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let registerVC = RegisterMenuController()
            if self?.childVC != registerVC {
                self?.childVC!.willMove(toParent: nil)
                self?.childVC!.view.removeFromSuperview()
                self?.childVC!.removeFromParent()
                self?.addChild(registerVC)
                self?.vcView!.addSubview(registerVC.view)
                registerVC.didMove(toParent: self)
                self?.childVC = registerVC
                self?.RecordFormDisappear()
              }
        }).disposed(by: disposeBag)
        
        footer?.settingsButton.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let settingVC = SettingViewController()
            if self?.childVC != settingVC {
                self?.childVC!.willMove(toParent: nil)
                self?.childVC!.view.removeFromSuperview()
                self?.childVC!.removeFromParent()
                self?.addChild(settingVC)
                self?.vcView!.addSubview(settingVC.view)
                settingVC.didMove(toParent: self)
                self?.childVC = settingVC
                self?.RecordFormDisappear()
              }
        }).disposed(by: disposeBag)
    }
    
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
extension BaseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
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
            recordForm?.targetPartTextField.textField!.text = menuViewModel?
                .workoutMenuArray[row].targetPart
            
            if recordForm?.targetPartTextField.textField!.text == nil {
                recordForm?.targetPartTextField.textField!.text = menuViewModel?
                    .workoutMenuArray[0].targetPart
            }
        case 2:
            recordForm?.workoutNameTextField.textField!.text = menuViewModel?
                .workoutMenuArray[selectTarget].workoutNames[row].workoutName
            
            if recordForm?.targetPartTextField.textField!.text == nil {
                recordForm?.targetPartTextField.textField!.text = menuViewModel?
                    .workoutMenuArray[selectTarget].workoutNames[0].workoutName
            }
        default: fatalError()
        }
    }
}

