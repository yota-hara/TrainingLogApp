//
//  PublicFooterView.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import Foundation

import UIKit

class PublicFooterView: UIView {
    
    let rectangleView1 = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
    let roundView1 = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
    let rectangleView2 = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
    let roundView2 = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
    
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
        backgroundColor = .clear

        
        let stackView = UIStackView(arrangedSubviews: [homeButton, recordWorkoutButton, registerMenuButton, settingsButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(rectangleView1)
        addSubview(roundView1)
        addSubview(rectangleView2)
        addSubview(roundView2)
        addSubview(stackView)
        addSubview(addWorkoutButton)
        
        rectangleView1.anchor(bottom: bottomAnchor, centerX: centerXAnchor, width: frame.width, height: 80)
        roundView1.anchor(centerY: rectangleView2.topAnchor, centerX: centerXAnchor, width: 70, height: 70)
        rectangleView2.anchor(bottom: bottomAnchor, centerX: centerXAnchor, width: frame.width, height: 75)
        roundView2.anchor(centerY: rectangleView2.topAnchor, centerX: centerXAnchor, width: 60, height: 60)
        
        stackView.anchor(top: rectangleView1.topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, leftPadding: 10, rightPadding: 10)
        addWorkoutButton.anchor(centerY: rectangleView2.topAnchor, centerX: centerXAnchor, width: 50, height: 50)
        
        rectangleView1.backgroundColor = .orange
        roundView1.layer.backgroundColor = UIColor.orange.cgColor
        roundView1.layer.cornerRadius = 70 / 2
        rectangleView2.backgroundColor = .white
        roundView2.layer.backgroundColor = UIColor.white.cgColor
        roundView2.layer.cornerRadius = 60 / 2
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - FooterButtonView

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

// MARK: - FooterButton

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
