//
//  RecordFormView.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit

class RecordFormView: UIView, UITextFieldDelegate {

    let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "トレーニングを記録する"
        label.textColor = UIColor.frameColor
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.layer.borderColor = UIColor.frameColor.cgColor
        label.layer.borderWidth = 4

        return label
    }()
    
    let targetPartLabel = RecordLabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30), text: "ターゲット部位")
    let targetPartTextField = RecordTextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    
    let workoutNameLabel = RecordLabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30), text: "トレーニング種目")
    let workoutNameTextField = RecordTextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    
    let weightLabel = RecordLabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30), text: "重量")
    let weightTextField = RecordTextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    
    let repsLabel = RecordLabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30), text: "レップ数")
    let repsTextField = RecordTextField(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    
    let memoTextView = RecordMemoView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    
    let memoLabel = RecordLabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30), text: "メモ")
    
    let registerButton = RecordButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.shadowOffset = .init(width: 1.5, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 15
        
        targetPartTextField.textField!.delegate = self
        workoutNameTextField.textField!.delegate = self
        
        addSubview(titleLabel)
        addSubview(targetPartLabel)
        addSubview(targetPartTextField)
        addSubview(workoutNameLabel)
        addSubview(workoutNameTextField)
        addSubview(weightLabel)
        addSubview(weightTextField)
        addSubview(repsLabel)
        addSubview(repsTextField)
        addSubview(memoTextView)
        addSubview(memoLabel)
        addSubview(registerButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        titleLabel.anchor(top: topAnchor,
                                   centerX: centerXAnchor,
                                   width: frame.size.width-110,
                                   height: 36,
                                   topPadding: 20)
        
        targetPartLabel.anchor(top: titleLabel.bottomAnchor,
                               left: targetPartTextField.leftAnchor,
                               width: 100,
                               height: 18,
                               topPadding: 20)
        
        targetPartTextField.anchor(top: targetPartLabel.bottomAnchor,
                                   centerX: centerXAnchor,
                                   width: frame.size.width-80,
                                   height: 30,
                                   topPadding: -2)
        
        workoutNameLabel.anchor(top: targetPartTextField.bottomAnchor,
                                left: targetPartTextField.leftAnchor,
                                width: 110,
                                height: 18,
                                topPadding: 10)
        
        workoutNameTextField.anchor(top: workoutNameLabel.bottomAnchor,
                                    centerX: centerXAnchor,
                                    width: frame.size.width-80,
                                    height: 30,
                                    topPadding: -2)
        
        weightLabel.anchor(top: workoutNameTextField.bottomAnchor,
                           left: targetPartTextField.leftAnchor,
                           width: 50,
                           height: 18,
                           topPadding: 10)
        
        weightTextField.anchor(top: weightLabel.bottomAnchor,
                               left: targetPartTextField.leftAnchor,
                               width: 100,
                               height: 30,
                               topPadding: -2)
        
        repsLabel.anchor(top: workoutNameTextField.bottomAnchor,
                           left: repsTextField.leftAnchor,
                           width: 65,
                           height: 18,
                           topPadding: 10)
        
        repsTextField.anchor(top: weightLabel.bottomAnchor,
                             right: targetPartTextField.rightAnchor,
                             width: 100,
                             height: 30,
                             topPadding: -2)
        
        memoLabel.anchor(top: repsTextField.bottomAnchor,
                         left: memoTextView.leftAnchor,
                         width: 50,
                         height: 18,
                         topPadding: 10)
        
        memoTextView.anchor(top: memoLabel.bottomAnchor,
                            bottom: registerButton.topAnchor,
                            centerX: centerXAnchor,
                            width: frame.size.width-80,
                            topPadding: -2,
                            bottomPadding: 20)
                
        registerButton.anchor(bottom: bottomAnchor,
                              centerX: centerXAnchor,
                              width: 80,
                              height: 30,
                              bottomPadding: 20)
    }
}

// MARK: - RecordTextField

class RecordTextField: UIView {
    
    var textField: UITextField?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        layer.backgroundColor = UIColor.frameColor.cgColor
        
        textField = UITextField()
        textField?.layer.cornerRadius = 8
        textField?.backgroundColor = .white
        textField?.textAlignment = .center
        textField?.placeholder = "uuuu"
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

// MARK: - RecordLabel

class RecordLabel: UIView {
    
    var label: UILabel?
    
    init(frame: CGRect, text: String) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        layer.backgroundColor = UIColor.frameColor.cgColor
        
        label = UILabel()
        label?.layer.cornerRadius = 8
        label?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        label?.textAlignment = .center
        label?.textColor = .white
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.backgroundColor = UIColor.frameColor.cgColor
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
        
        textView = UITextView()
        textView?.layer.backgroundColor = UIColor.white.cgColor
        textView?.layer.cornerRadius = 8
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.backgroundColor = UIColor.orange.cgColor
        layer.cornerRadius = 8
        setTitle("記録", for: .normal)
        tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
