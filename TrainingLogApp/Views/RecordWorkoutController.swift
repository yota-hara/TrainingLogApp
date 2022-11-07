//
//  RecordWorkoutController.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit
import RxSwift
import RxCocoa

class RecordWorkoutController: UIViewController, ViewControllerDelegate {
    
    // MARK: - Properties & UIParts
    
    var footer: PublicFooterView?
    var viewModel: FormValidateViewModel?
    var workoutMenuViewModel: WorkoutMenuViewModel?
    private let disposeBag = DisposeBag()
    
    var recordForm: RecordFormView?
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        viewModel = ViewModel()
        workoutMenuViewModel = WorkoutMenuViewModel()
        footer = PublicFooterView()
        footerBind()
        view.addSubview(footer!)
        
        recordForm = RecordFormView()
        recordForm?.alpha = 0
        view.addSubview(recordForm!)
        
        setupTextFields()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        footer?.anchor(bottom: view.bottomAnchor, left: view.leftAnchor, width: view.frame.size.width, height: 100)
        recordForm?.anchor(top: view.topAnchor, centerX: view.centerXAnchor, width: view.frame.size.width-40, height: 400, topPadding: 100)

    }

    
    
    func bindRecordForm() {
        recordForm?.workoutNameTextField.textField?.rx.text.asDriver().drive(onNext: { _ in
            
            print(self.recordForm?.workoutNameTextField.textField?.text! as Any)
        }).disposed(by: disposeBag)
        
        
    }
    
    func footerBind() {
        
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
    
    private func setupTextFields() {
        // targetPartTextField
        let targetPartPicker = UIPickerView()
        targetPartPicker.tag = 1
        targetPartPicker.delegate = self
        targetPartPicker.dataSource = self
        recordForm?.targetPartTextField.textField!.inputView = targetPartPicker
        let targetPartToolbar = UIToolbar()
        targetPartToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
        let space1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem1 = UIBarButtonItem(title: "次へ", style: .done, target: self, action: #selector(donePicker1))
        targetPartToolbar.setItems([space1, doneButtonItem1], animated: true)
        recordForm?.targetPartTextField.textField!.inputAccessoryView = targetPartToolbar
        
//        // workoutNameTextField
//        let workoutNamePicker = UIPickerView()
//        workoutNamePicker.tag = 2
//        workoutNamePicker.delegate = self
//        workoutNamePicker.dataSource = self
//        setWorkoutView.workoutNameTextField.inputView = workoutNamePicker
//        let workoutNameToolbar = UIToolbar()
//        workoutNameToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
//        let space2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneButtonItem2 = UIBarButtonItem(title: "次へ", style: .done, target: self, action: #selector(donePicker2))
//        workoutNameToolbar.setItems([space2, doneButtonItem2], animated: true)
//        setWorkoutView.workoutNameTextField.inputAccessoryView = workoutNameToolbar
//
//        // weightTextField
//        let weightToolbar = UIToolbar()
//        weightToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
//        let space3 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneButtonItem3 = UIBarButtonItem(title: "次へ", style: .done, target: self, action: #selector(donePicker3))
//        weightToolbar.setItems([space3, doneButtonItem3], animated: true)
//        setWorkoutView.weightTextField.inputAccessoryView = weightToolbar
//
//        // repsTextField
//        let repsToolbar = UIToolbar()
//        repsToolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
//        let space4 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneButtonItem4 = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(donePicker4))
//        repsToolbar.setItems([space4, doneButtonItem4], animated: true)
//        setWorkoutView.repsTextField.inputAccessoryView = repsToolbar
    }
    
    @objc func donePicker1() {
        recordForm?.workoutNameTextField.textField!.becomeFirstResponder()
    }
//    @objc func donePicker2() {
//        setWorkoutView.weightTextField.becomeFirstResponder()
//    }
//    @objc func donePicker3() {
//        setWorkoutView.repsTextField.becomeFirstResponder()
//    }
//    @objc func donePicker4() {
//        setWorkoutView.repsTextField.resignFirstResponder()
//    }
    
    //MARK: - UITextFieldDelegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            recordForm?.workoutNameTextField.textField!.becomeFirstResponder()
//        case 1:
//            setWorkoutView.weightTextField.becomeFirstResponder()
//        case 2:
//            setWorkoutView.repsTextField.becomeFirstResponder()
//        case 3:
//            setWorkoutView.repsTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    
}

extension RecordWorkoutController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            
            return (workoutMenuViewModel?.workoutMenuArray.count)!
        } else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return workoutMenuViewModel?.workoutMenuArray[row].targetPart

        } else {
            return "tt"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            recordForm?.targetPartTextField.textField!.text = workoutMenuViewModel?.workoutMenuArray[row].targetPart
        } else {
            recordForm?.workoutNameTextField.textField!.text = "111"
        }
    }
    
}
