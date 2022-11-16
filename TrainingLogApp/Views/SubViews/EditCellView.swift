//
//  RecordFormView.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit

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
    
    init(frame: CGRect, item: WorkoutRecordCellViewModel) {
        super.init(frame: frame)
                
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
        
        targetPartTextField?.textField?.text = item.workoutObject.targetPart
        targetPartTextField?.textField?.textColor = textColor
        workoutNameTextField?.textField?.text = item.workoutObject.workoutName
        workoutNameTextField?.textField?.textColor = textColor
        weightTextField?.textField?.text = item.workoutObject.weight.description
        weightTextField?.textField?.textColor = textColor
        repsTextField?.textField?.text = item.workoutObject.reps.description
        repsTextField?.textField?.textColor = textColor
        memoTextView?.textView?.text = item.workoutObject.memo
        memoTextView?.textView?.textColor = textColor
        
        addSubviews()
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
}

