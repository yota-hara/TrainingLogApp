//
//  RecordFormView.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit
import TextFieldEffects

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
    
    let targetPartLabel = RecordLabel(frame: .zero, text: "ターゲット部位")
    let targetPartTextField = RecordTextField()
    
    let workoutNameLabel = RecordLabel(frame: .zero, text: "トレーニング種目")
    let workoutNameTextField = RecordTextField()
    
    let weightLabel = RecordLabel(frame: .zero, text: "重量")
    let weightTextField = RecordTextField()
    
    let repsLabel = RecordLabel(frame: .zero, text: "レップ数")
    let repsTextField = RecordTextField()
    
    let memoTextView = RecordMemoView()
    
    let memoLabel = RecordLabel(frame: .zero, text: "メモ")
    
    let registerButton: UIButton = {
       let button = UIButton()
        button.layer.backgroundColor = UIColor.orange.cgColor
        button.layer.cornerRadius = 8
        button.setTitle("記録", for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
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
//        label?.layer.backgroundColor = UIColor.white.cgColor
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
