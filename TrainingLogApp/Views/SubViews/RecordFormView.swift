//
//  RecordFormView.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit
import RxSwift
import RxCocoa

class RecordFormView: UIView, UITextFieldDelegate {
    
    private var selectTarget = 0 // argetPartで何番目を選択したか
    private let frameColor = UIColor.darkGray

    private let disposeBag = DisposeBag()
    
    private var validationViewModel: FormValidateViewModel?
    private var menuViewModel: WorkoutMenuViewModel?
    private var recordViewModel: WorkoutRecordViewModel?
    
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
    var registerButton: RecordButton?
    var clearButton: RecordButton?
    
    init(frame: CGRect, recordViewModel: WorkoutRecordViewModel, menuViewModel: WorkoutMenuViewModel) {
        super.init(frame: frame)
        self.recordViewModel = recordViewModel
        self.menuViewModel = menuViewModel
        
        validationViewModel = FormValidateViewModel()
        
        let mainBackgroundColor = UIColor.darkGray
        let mainForegroundColor = UIColor.white
        let buttonTintColor = UIColor.white
        let registerColor = UIColor.orange
        let clearColor = UIColor.systemMint
        
        self.backgroundColor = mainForegroundColor
        layer.cornerRadius = 20
        layer.shadowOffset = .init(width: 1.5, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 15

        titleLabel = RecordTitleLabel(frame: .zero,
                                      keyword: "記録",
                                      textColor: mainBackgroundColor,
                                      accentColor: registerColor,
                                      addLine: false
        )
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
        
        registerButton = RecordButton(frame: .zero,
                                      title: "記録",
                                      backgroundColor: registerColor,
                                      tintColor: buttonTintColor)
        
        clearButton = RecordButton(frame: .zero,
                                   title: "クリア",
                                   backgroundColor: clearColor,
                                   tintColor: buttonTintColor)
        
        targetPartTextField?.textField!.delegate = self
        workoutNameTextField?.textField!.delegate = self
        
        addSubviews()
        setupButtonActions()
        setupTextFields()
        setupPickers()
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
        addSubview(memoLabel!)
        addSubview(memoTextView!)
        addSubview(registerButton!)
        addSubview(clearButton!)
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
        
        // registerButton, clearButton
        let buttonHorizontalPadding: CGFloat = 5
        let buttonVerticalPadding: CGFloat = 20
        let buttonWidth: CGFloat = 80
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
                             bottom: registerButton!.topAnchor,
                             centerX: centerXAnchor,
                             width: frame.size.width - textFieldHorizontalPadding * 2,
                             topPadding: textFieldTopPadding,
                             bottomPadding: 20)
        
        registerButton?.anchor(bottom: bottomAnchor,
                               left: memoTextView!.leftAnchor,
                               width: buttonWidth,
                               height: buttonHeight,
                               bottomPadding: buttonVerticalPadding,
                               leftPadding: buttonHorizontalPadding)
        
        clearButton?.anchor(bottom: bottomAnchor,
                            right: memoTextView!.rightAnchor,
                            width: buttonWidth,
                            height: buttonHeight,
                            bottomPadding: buttonVerticalPadding,
                            rightPadding: buttonHorizontalPadding)
    }
    
    private func setupButtonActions() {
        validationViewModel?.validRegisterDriver.drive(onNext: { validAll in
            self.registerButton?.isEnabled = validAll
            self.registerButton?.layer.backgroundColor = validAll ? UIColor.orange.cgColor : UIColor.gray.cgColor
        }).disposed(by: disposeBag)
        
        registerButton?.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.registerWorkout()
            self?.endEditing(true)
        }).disposed(by: disposeBag)
        
        clearButton?.rx.tap.asDriver().drive(onNext: { [weak self] _ in
            self?.targetPartTextField?.textField?.text = ""
            self?.workoutNameTextField?.textField?.text = ""
            self?.weightTextField?.textField?.text = ""
            self?.repsTextField?.textField?.text = ""
            self?.memoTextView?.textView?.text = ""
        }).disposed(by: disposeBag)
    }
    
    private func setupTextFields() {
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
        
        setupPickers()
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
    
    private func registerWorkout() {
        let target = targetPartTextField?.textField?.text!
        let workoutName = workoutNameTextField?.textField?.text!
        let weight = weightTextField?.textField?.text!
        let reps = repsTextField?.textField?.text!
        let memo = memoTextView?.textView?.text!
        
        recordViewModel?.onTapRegister(target: target!,
                                       workoutName: workoutName!,
                                       weight: weight!,
                                       reps: reps!,
                                       memo: memo!)
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
extension RecordFormView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
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



// MARK: - RecordTextField

class RecordTextField: UIView {
    
    var textField: UITextField?
    
    init(frame: CGRect, backgroundColor: UIColor, foregroundColor: UIColor) {
        super.init(frame: frame)
        
        let outerRadius: CGFloat = 10
        let innerRadius: CGFloat = 8
        
        layer.cornerRadius = outerRadius
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        layer.backgroundColor = backgroundColor.cgColor
        
        textField = UITextField()
        textField?.layer.cornerRadius = innerRadius
        textField?.backgroundColor = foregroundColor
        textField?.textAlignment = .center
        addSubview(textField!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        textField?.anchor(top: topAnchor,
                         bottom: bottomAnchor,
                         left: leftAnchor,
                         right: rightAnchor,
                         topPadding: 4,
                         bottomPadding: 4,
                         leftPadding: 4,
                         rightPadding: 4)
    }
    
}

class RecordTitleLabel: UILabel {
    
    init(frame: CGRect, keyword: String, textColor: UIColor, accentColor: UIColor, addLine: Bool) {
        super.init(frame: frame)
        
        let font = UIFont.boldSystemFont(ofSize: 20)
        
        let headStringAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : textColor,
            .font : font
        ]
        let headString = NSAttributedString(string: "トレーニングを", attributes: headStringAttributes)

        let keywordStringAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : accentColor,
            .font : font
            ]
        let keyword = NSAttributedString(string: keyword, attributes: keywordStringAttributes)

        let footStringAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : textColor,
            .font : font
        ]
        let footString = NSAttributedString(string: "する", attributes: footStringAttributes)

        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(headString)
        mutableAttributedString.append(keyword)
        mutableAttributedString.append(footString)

        if addLine {
            mutableAttributedString.addAttributes([
                .underlineStyle: NSUnderlineStyle.thick.rawValue,
                .underlineColor: accentColor],
                range: NSRange(location: 0, length: mutableAttributedString.length)
                )
        }
        
        self.attributedText = mutableAttributedString
        self.textAlignment = .center
        self.layer.backgroundColor = UIColor.clear.cgColor
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - RecordLabel

class RecordLabel: UIView {
    
    var label: UILabel?
    
    init(frame: CGRect, text: String, backgroundColor: UIColor, foregroundColor: UIColor) {
        super.init(frame: frame)
        
        let outerRadius: CGFloat = 10
        let innerRadius: CGFloat = 8
        
        layer.cornerRadius = outerRadius
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        layer.backgroundColor = backgroundColor.cgColor
        
        label = UILabel()
        label?.layer.cornerRadius = innerRadius
        label?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        label?.textAlignment = .center
        label?.textColor = foregroundColor
        label?.text = text
        label?.font = UIFont.boldSystemFont(ofSize: 12)
        addSubview(label!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        label?.anchor(top: topAnchor,
                         bottom: bottomAnchor,
                         left: leftAnchor,
                         right: rightAnchor,
                         topPadding: 0,
                         leftPadding: 0,
                         rightPadding: 0)
    }
}
// MARK: - RecordMemoView

class RecordMemoView: UIView {
    var textView: UITextView?
    
    init(frame: CGRect, backgroundColor: UIColor, foregroundColor: UIColor) {
        super.init(frame: frame)
        
        let outerRadius: CGFloat = 10
        let innerRadius: CGFloat = 8
        
        layer.backgroundColor = backgroundColor.cgColor
        layer.cornerRadius = outerRadius
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        
        textView = UITextView()
        textView?.backgroundColor = foregroundColor
        textView?.layer.cornerRadius = innerRadius
        addSubview(textView!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        textView?.anchor(top: topAnchor,
                         bottom: bottomAnchor,
                         left: leftAnchor,
                         right: rightAnchor,
                         topPadding: 4,
                         bottomPadding: 4,
                         leftPadding: 4,
                         rightPadding: 4)
    }
    
}

// MARK: - RecordButton
class RecordButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: []) {
                    self.transform = .init(scaleX: 0.92, y: 0.92)
                    self.alpha = 0.9
                    self.layoutIfNeeded()
                }
            } else {
                self.transform = .identity
                self.alpha = 1
                self.layoutIfNeeded()
            }
        }
    }
    
    init(frame: CGRect, title: String, backgroundColor: UIColor, tintColor: UIColor) {
        super.init(frame: frame)
        
        let cornerRadius: CGFloat = 10
        
        setTitle(title, for: .normal)
        layer.backgroundColor = backgroundColor.cgColor
        layer.cornerRadius = cornerRadius
        self.tintColor = tintColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
