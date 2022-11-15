//
//  RecordFormView.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit

class RecordFormView: UIView, UITextFieldDelegate {

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
    var registerButton: RecordButton?
    var clearButton: RecordButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
                                      text: "トレーニングを記録する",
                                      backgroundColor: mainBackgroundColor,
                                      foregroundColor: mainForegroundColor)
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
    
    init(frame: CGRect, text: String, backgroundColor: UIColor, foregroundColor: UIColor) {
        super.init(frame: frame)
        
        let cornerRadius: CGFloat = 10
        self.text = "トレーニングを記録する"
        self.textColor = backgroundColor
        self.font = UIFont.boldSystemFont(ofSize: 22)
        self.textAlignment = .center
        self.layer.backgroundColor = foregroundColor.cgColor
        self.layer.cornerRadius = cornerRadius

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
        textView?.layer.backgroundColor = foregroundColor.cgColor
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
