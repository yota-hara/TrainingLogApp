//
//  PublicFooterView.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import Foundation

import UIKit

class PublicFooterView: UIView {
    
    let homeButton = FooterButtonView(frame: .zero, width: 50, imageName: "house.fill", text: "ホーム", labelWidth: 30)
    let recordWorkoutButton = FooterButtonView(frame: .zero, width: 50, imageName: "book.fill", text: "記録", labelWidth: 30)
    let registerMenuButton = FooterButtonView(frame: .zero, width: 50, imageName: "tablecells.fill", text: "種目", labelWidth: 30)
    let settingsButton = FooterButtonView(frame: .zero, width: 50, imageName: "text.justify", text: "設定", labelWidth: 30)
    
    let addWorkoutButton: FooterButton = {
        
        let button = FooterButton()
        button.backgroundColor = .orange
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 25
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        
        

        let stackView = UIStackView(arrangedSubviews: [homeButton, recordWorkoutButton, registerMenuButton, settingsButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        addSubview(addWorkoutButton)
        stackView.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, topPadding: 25, leftPadding: 10, rightPadding: 10)
        addWorkoutButton.anchor(bottom: stackView.topAnchor, centerX: centerXAnchor, width: 50, height: 50, bottomPadding: -25)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class FooterButtonView: UIView {
    var label = UILabel()

    var button: FooterButton?
    
    init(frame: CGRect, width: CGFloat, imageName: String, text: String, labelWidth: CGFloat) {
        super.init(frame: frame)
        
        clipsToBounds = false
        
        button = FooterButton(type: .system)
        button?.setImage(UIImage(systemName: imageName)?.resize(size: .init(width: width*0.7, height: width*0.7)), for: .normal)
        button?.translatesAutoresizingMaskIntoConstraints = false
        button?.tintColor = .orange
        button?.backgroundColor = .clear
//        button?.layer.cornerRadius = 10
//        button?.layer.shadowOffset = .init(width: 1.5, height: 2)
//        button?.layer.shadowColor = UIColor.black.cgColor
//        button?.layer.shadowOpacity = 0.5
//        button?.layer.shadowRadius = 15
        
        addSubview(button!)
        button?.anchor(top: topAnchor, centerX: centerXAnchor, width: width, height: width, topPadding: 10)

        label.text = text
        label.textColor = UIColor.orange
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 10)

        addSubview(label)
        label.anchor(bottom: button!.bottomAnchor, centerX: centerXAnchor,  width: labelWidth, height: 14)
}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FooterButton: UIButton {
    
    //ボタンを押しているときに縮小拡大するアニメーション
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: []) {
                    //ハイライトになっている時、大きさを0.8倍に
                    self.transform = .init(scaleX: 0.92, y: 0.92)
                    self.alpha = 0.9
                    self.layoutIfNeeded()
                }
            } else {
                //ハイライトが消えると、元の大きさに
                self.transform = .identity
                self.alpha = 1
                self.layoutIfNeeded()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
