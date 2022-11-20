//
//  RecordFormView.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit
import RxSwift

class EditCellView: UIView, UITextFieldDelegate {

    let frameColor = UIColor.darkGray
    var titleLabel: RecordTitleLabel?
    
    var targetPartLabel: RecordLabel?
    var targetPartTextField: RecordTextField?
    var workoutNameLabel: RecordLabel?
    var workoutNameTextField: RecordTextField?
    var weightLabel: RecordLabel?
    var weightTextField: RecordTextField?
    var repsLabel: RecordLabel?
    var repsTextField: RecordTextField?
    var memoLabel: RecordLabel?
    var memoTextView: RecordMemoView?
    var editButton: RecordButton?
    var cancelButton: RecordButton?
    
    private var selectTarget = 0
    private let disposeBag = DisposeBag()
    private var validationViewModel: FormValidateViewModel?
    private var recordViewModel: WorkoutRecordViewModel?
    private var menuViewModel: WorkoutMenuViewModel?
    private var item: WorkoutRecordCellViewModel?
    
    init(frame: CGRect, row: Int, recordViewModel: WorkoutRecordViewModel, menuViewModel: WorkoutMenuViewModel) {
        super.init(frame: frame)
                
        self.recordViewModel = recordViewModel
        self.validationViewModel = FormValidateViewModel()
        self.menuViewModel = menuViewModel
        self.item = recordViewModel.returnItem(row: row)
        
        let mainBackgroundColor = UIColor.gray
        let mainForegroundColor = UIColor.white.withAlphaComponent(0.9)
        let buttonTintColor = UIColor.white
        let registerColor = UIColor.orange
        let clearColor = UIColor.systemMint
        
        self.backgroundColor = .white.withAlphaComponent(0.87)
        layer.cornerRadius = 20
        layer.shadowOffset = .init(width: 1.5, height: 2)
        layer.shadowColor = UIColor.black.cgColor.copy(alpha: 0.8)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 15
  
        titleLabel = RecordTitleLabel(frame: .zero,
                                      keyword: "編集",
                                      textColor: mainBackgroundColor,
                                      accentColor: registerColor,
                                      addLine: true)
        targetPartLabel = RecordLabel(frame: .zero,
                                      text: "ターゲット部位",
                                      backgroundColor: mainBackgroundColor,
                                      foregroundColor: mainForegroundColor)
        targetPartTextField = RecordTextField(frame: .zero, backgroundColor: mainBackgroundColor,
                                              foregroundColor: mainForegroundColor)
        workoutNameLabel = RecordLabel(frame: .zero,
                                       text: "トレーニング種目",
                                       backgroundColor: mainBackgroundColor,
                                       foregroundColor: mainForegroundColor)
        workoutNameTextField = RecordTextField(frame: .zero,
                                               backgroundColor: mainBackgroundColor,
                                               foregroundColor: mainForegroundColor)
        weightLabel = RecordLabel(frame: .zero, text: "重量",
                                  backgroundColor: mainBackgroundColor,
                                  foregroundColor: mainForegroundColor)
        weightTextField = RecordTextField(frame: .zero,
                                          backgroundColor: mainBackgroundColor,
                                          foregroundColor: mainForegroundColor)
        repsLabel = RecordLabel(frame: .zero,
                                text: "レップ数",
                                backgroundColor: mainBackgroundColor,
                                foregroundColor: mainForegroundColor)
        repsTextField = RecordTextField(frame: .zero,
                                        backgroundColor: mainBackgroundColor,
                                        foregroundColor: mainForegroundColor)
        memoLabel = RecordLabel(frame: .zero,
                                text: "メモ", backgroundColor: mainBackgroundColor,
                                foregroundColor: mainForegroundColor)
        memoTextView = RecordMemoView(frame: .zero,
                                      backgroundColor: mainBackgroundColor,
                                      foregroundColor: mainForegroundColor)
        
        editButton = RecordButton(frame: .zero,
                                      title: "保存する",
                                      backgroundColor: registerColor,
                                      tintColor: buttonTintColor)
        cancelButton = RecordButton(frame: .zero,
                                   title: "キャンセル",
                                   backgroundColor: clearColor,
                                   tintColor: buttonTintColor)
        
        targetPartTextField?.textField!.delegate = self
        workoutNameTextField?.textField!.delegate = self

        let textColor = UIColor.black
        
        targetPartTextField?.textField?.text = item?.workoutObject.targetPart
        targetPartTextField?.textField?.textColor = textColor
        workoutNameTextField?.textField?.text = item?.workoutObject.workoutName
        workoutNameTextField?.textField?.textColor = textColor
        weightTextField?.textField?.text = item?.workoutObject.weight.description
        weightTextField?.textField?.textColor = textColor
        repsTextField?.textField?.text = item?.workoutObject.reps.description
        repsTextField?.textField?.textColor = textColor
        memoTextView?.textView?.text = item?.workoutObject.memo
        memoTextView?.textView?.textColor = textColor
        
        addSubviews()
        setupTextFields()
        setupButtonActions()
        
    }
    
    private func addSubviews() {
        addSubview(titleLabel!)
        addSubview(targetPartLabel!)
        addSubview(targetPartTextField!)
        addSubview(workoutNameLabel!)
        addSubview(workoutNameTextField!)
        addSubview(weightLabel!)
        addSubview(weightTextField!)
        addSubview(repsLabel!)
        addSubview(repsTextField!)
        addSubview(memoTextView!)
        addSubview(memoLabel!)
        addSubview(editButton!)
        addSubview(cancelButton!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        // titleLabel
        let titleHorizontalPadding: CGFloat = 55
        let titleVerticalPadding: CGFloat = 20
        let titlewidth: CGFloat = frame.size.width - titleHorizontalPadding * 2
        let titleHeight: CGFloat = 36
        
        // targetPartLabel, workoutNameLabel, weightLabel, repsLabel, memoLabel
        let labelTopPadding: CGFloat = 10
        let labelHeight: CGFloat = 18
        
        // targetPartTextField, workoutNameTextField
        let textFieldTopPadding: CGFloat = -2
        let textFieldHorizontalPadding: CGFloat = 40
        let textFieldHeight: CGFloat = 30
        
        // weightTextField, repsTextField
        let shortTextFieldWidth: CGFloat = 100
        let shortTextFieldHeight: CGFloat = textFieldHeight
        
        // editButton, cancelButton
        let buttonHorizontalPadding: CGFloat = 5
        let buttonVerticalPadding: CGFloat = 20
        let buttonWidth: CGFloat = 100
        let buttonHeight: CGFloat = 30
        
        titleLabel?.anchor(top: topAnchor,
                                   centerX: centerXAnchor,
                                   width: titlewidth,
                                   height: titleHeight,
                                   topPadding: titleVerticalPadding)
        
        targetPartLabel?.anchor(top: titleLabel!.bottomAnchor,
                               left: targetPartTextField!.leftAnchor,
                               width: 100,
                               height: labelHeight,
                               topPadding: titleVerticalPadding)
        
        targetPartTextField?.anchor(top: targetPartLabel!.bottomAnchor,
                                   centerX: centerXAnchor,
                                   width: frame.size.width - textFieldHorizontalPadding * 2,
                                   height: textFieldHeight,
                                   topPadding: textFieldTopPadding)
        
        workoutNameLabel?.anchor(top: targetPartTextField!.bottomAnchor,
                                left: targetPartTextField!.leftAnchor,
                                width: 110,
                                height: labelHeight,
                                topPadding: labelTopPadding)
        
        workoutNameTextField?.anchor(top: workoutNameLabel!.bottomAnchor,
                                    centerX: centerXAnchor,
                                    width: frame.size.width - textFieldHorizontalPadding * 2,
                                    height: textFieldHeight,
                                    topPadding: textFieldTopPadding)
        
        weightLabel?.anchor(top: workoutNameTextField!.bottomAnchor,
                           left: targetPartTextField!.leftAnchor,
                           width: 50,
                           height: labelHeight,
                           topPadding: labelTopPadding)
        
        weightTextField?.anchor(top: weightLabel!.bottomAnchor,
                               left: targetPartTextField!.leftAnchor,
                               width: shortTextFieldWidth,
                               height: shortTextFieldHeight,
                               topPadding: textFieldTopPadding)
        
        repsLabel?.anchor(top: workoutNameTextField!.bottomAnchor,
                           left: repsTextField!.leftAnchor,
                           width: 65,
                           height: labelHeight,
                           topPadding: labelTopPadding)
        
        repsTextField?.anchor(top: weightLabel!.bottomAnchor,
                             right: targetPartTextField!.rightAnchor,
                             width: shortTextFieldWidth,
                             height: shortTextFieldHeight,
                             topPadding: textFieldTopPadding)
        
        memoLabel?.anchor(top: repsTextField!.bottomAnchor,
                          left: memoTextView!.leftAnchor,
                          width: 50,
                          height: labelHeight,
                          topPadding: labelTopPadding)
        
        memoTextView?.anchor(top: memoLabel!.bottomAnchor,
                             bottom: editButton!.topAnchor,
                             centerX: centerXAnchor,
                             width: frame.size.width - textFieldHorizontalPadding * 2,
                             topPadding: textFieldTopPadding,
                             bottomPadding: 20)
        
        editButton?.anchor(bottom: bottomAnchor,
                               left: memoTextView!.leftAnchor,
                               width: buttonWidth,
                               height: buttonHeight,
                               bottomPadding: buttonVerticalPadding,
                               leftPadding: buttonHorizontalPadding)
        
        cancelButton?.anchor(bottom: bottomAnchor,
                            right: memoTextView!.rightAnchor,
                            width: buttonWidth,
                            height: buttonHeight,
                            bottomPadding: buttonVerticalPadding,
                            rightPadding: buttonHorizontalPadding)
    }
    
    private func setupTextFields(){
        
        setupPickers()
        
        targetPartTextField?.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.validationViewModel?.targetTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        workoutNameTextField?.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.validationViewModel?.workoutTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        weightTextField?.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.validationViewModel?.weightTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        repsTextField?.textField?.rx.text.asDriver().drive(onNext: { [weak self] text in
            self?.validationViewModel?.repsTextInput.onNext(text ?? "")
        }).disposed(by: disposeBag)
        
        validationViewModel?.validRegisterDriver.drive(onNext: { validAll in
            self.editButton?.isEnabled = validAll
            self.editButton?.layer.backgroundColor = validAll ? UIColor.orange.cgColor : UIColor.gray.cgColor
        }).disposed(by: disposeBag)
    }
    
    private func setupButtonActions() {
        
        let readytransform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0, animations: {
            self.transform = readytransform
        })
        let transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.animate(withDuration: 0.5, animations: {
            self.transform = transform
        })
        
        // editButton Action
        editButton?.rx.tap.asDriver().drive(onNext: { [weak self] in
            
            self?.editWorkout()
            
            let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.5, animations: {
                self?.transform = transform
                self?.alpha = 0
            }) { _ in
                self?.isHidden = true
                self?.recordViewModel?.editCellViewAperr.accept(false)
            }
        }).disposed(by: disposeBag)
        
        // cancelButton Action
        cancelButton?.rx.tap.asDriver().drive(onNext: { [weak self] in
            
            let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.5, animations: {
                self?.transform = transform
                self?.alpha = 0
            }) { _ in
                self?.isHidden = true
                self?.recordViewModel?.editCellViewAperr.accept(false)
            }
        }).disposed(by: disposeBag)
    }
    
    private func editWorkout() {
        let target = targetPartTextField?.textField?.text
        let workoutName = workoutNameTextField?.textField?.text
        let weight = weightTextField?.textField?.text
        let reps = repsTextField?.textField?.text
        let memo = memoTextView?.textView?.text
        
        recordViewModel?.onEditItem(target: target!,
                                    workoutName: workoutName!,
                                    weight: weight!,
                                    reps: reps!,
                                    memo: memo!,
                                    item: item!)
    }
    
    private func setupPickers() {
        // targetPartTextField
        let targetPartPicker = UIPickerView()
        targetPartPicker.tag = 1
        targetPartPicker.delegate = self
        targetPartPicker.dataSource = self
        targetPartTextField?.textField!.inputView = targetPartPicker
        let targetPartToolbar = UIToolbar()
        targetPartToolbar.frame = CGRect(x: 0, y: 0, width: frame.width, height: 30)
        let targetSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let targetDoneButtonItem = UIBarButtonItem(title: "次へ",
                                                   style: .done,
                                                   target: self,
                                                   action: #selector(targetDonePicker))
        targetPartToolbar.setItems([targetSpace, targetDoneButtonItem], animated: true)
        targetPartTextField?.textField!.inputAccessoryView = targetPartToolbar
        targetPartTextField?.textField!.delegate = self
        
        // workoutNameTextField
        let workoutNamePicker = UIPickerView()
        workoutNamePicker.tag = 2
        workoutNamePicker.delegate = self
        workoutNamePicker.dataSource = self
        workoutNameTextField?.textField!.inputView = workoutNamePicker
        let workoutNameToolbar = UIToolbar()
        workoutNameToolbar.frame = CGRect(x: 0, y: 0, width: frame.width, height: 30)
        let workoutNameSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let workoutNameDoneButtonItem = UIBarButtonItem(title: "次へ",
                                                        style: .done,
                                                        target: self,
                                                        action: #selector(workoutNameDonePicker))
        workoutNameToolbar.setItems([workoutNameSpace, workoutNameDoneButtonItem], animated: true)
        workoutNameTextField?.textField!.inputAccessoryView = workoutNameToolbar
        workoutNameTextField?.textField!.delegate = self
        
        // weightTextField
        weightTextField?.textField!.keyboardType = .decimalPad
        let weightToolbar = UIToolbar()
        weightToolbar.frame = CGRect(x: 0, y: 0, width: frame.width, height: 30)
        let weightSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let weightDoneButtonItem = UIBarButtonItem(title: "次へ",
                                                   style: .done,
                                                   target: self,
                                                   action: #selector(weightDonePicker))
        weightToolbar.setItems([weightSpace, weightDoneButtonItem], animated: true)
        weightTextField?.textField!.inputAccessoryView = weightToolbar
        weightTextField?.textField!.delegate = self
        
        // repsTextField
        repsTextField?.textField!.keyboardType = .numberPad
        let repsToolbar = UIToolbar()
        repsToolbar.frame = CGRect(x: 0, y: 0, width: frame.width, height: 30)
        let repsSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let repsDoneButtonItem = UIBarButtonItem(title: "次へ",
                                                 style: .done,
                                                 target: self,
                                                 action: #selector(repsDonePicker))
        repsToolbar.setItems([repsSpace, repsDoneButtonItem], animated: true)
        repsTextField?.textField!.inputAccessoryView = repsToolbar
        repsTextField?.textField!.delegate = self
        
        //memoTextView
        memoTextView?.textView!.keyboardType = .default
        let memoToolbar = UIToolbar()
        memoToolbar.frame = CGRect(x: 0, y: 0, width: frame.width, height: 30)
        let space5 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem5 = UIBarButtonItem(title: "OK",
                                              style: .done,
                                              target: self,
                                              action: #selector(memoDonePicker))
        memoToolbar.setItems([space5, doneButtonItem5], animated: true)
        memoTextView?.textView!.inputAccessoryView = memoToolbar

    }
    
    @objc func targetDonePicker() {
        workoutNameTextField?.textField!.becomeFirstResponder()
    }
    @objc func workoutNameDonePicker() {
        weightTextField?.textField!.becomeFirstResponder()
    }
    @objc func weightDonePicker() {
        repsTextField?.textField!.becomeFirstResponder()
    }
    @objc func repsDonePicker() {
        memoTextView?.textView!.becomeFirstResponder()
    }
    @objc func memoDonePicker() {
        memoTextView?.textView!.resignFirstResponder()
    }
}

// MARK: - UIPickerView

extension EditCellView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
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
            targetPartTextField?.textField!.text = menuViewModel?
                .workoutMenuArray[row].targetPart
            
            if targetPartTextField?.textField!.text == nil {
                targetPartTextField?.textField!.text = menuViewModel?
                    .workoutMenuArray[0].targetPart
            }
        case 2:
            workoutNameTextField?.textField!.text = menuViewModel?
                .workoutMenuArray[selectTarget].workoutNames[row].workoutName
            
            if targetPartTextField?.textField!.text == nil {
                targetPartTextField?.textField!.text = menuViewModel?
                    .workoutMenuArray[selectTarget].workoutNames[0].workoutName
            }
        default: fatalError()
        }
    }
}
