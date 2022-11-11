//
//  PublicFooterView.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit

class TabButtonFooterView: UIView {
    
    var backgroundView: FooterBackgroundView?
    
    var homeButton: FooterButtonView?
    var recordButton: FooterButtonView?
    var menuButton: FooterButtonView?
    var settingsButton: FooterButtonView?
    
    var registerButton: FooterButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        
        let mainBackgroundColor = UIColor.orange
        let mainForegroundColor = UIColor.white
        
        let buttonBackgroundColor = UIColor.clear
        let buttonForegroundColor = UIColor.orange
        
        let lineWidth: CGFloat = 5 // fotter全体のボーダーの幅
        let padding: CGFloat = 20
        let buttonWidth: CGFloat = 60
        let buttonY: CGFloat = center.y

        backgroundView = FooterBackgroundView(frame: CGRect(x: 0,
                                                            y: 0,
                                                            width: frame.size.width,
                                                            height: frame.size.height),
                                              lineWidth: lineWidth,
                                              backgroundColor: mainBackgroundColor,
                                              foregroundColor: mainForegroundColor)
        
        homeButton = FooterButtonView(frame: CGRect(x: padding,
                                                    y: buttonY,
                                                    width: buttonWidth,
                                                    height: buttonWidth),
                                      imageName: "house.fill",
                                      labelText: "ホーム",
                                      backgroundColor: buttonBackgroundColor,
                                      foregroundColor: buttonForegroundColor)
        
        recordButton = FooterButtonView(frame: CGRect(x: padding * 2 + buttonWidth,
                                                      y: buttonY,
                                                      width: buttonWidth,
                                                      height: buttonWidth),
                                        imageName: "book.fill",
                                        labelText: "記録",
                                        backgroundColor: buttonBackgroundColor,
                                        foregroundColor: buttonForegroundColor)
        
        menuButton = FooterButtonView(frame: CGRect(x: frame.maxX - buttonWidth * 2 - padding * 2,
                                                    y: buttonY,
                                                    width: buttonWidth,
                                                    height: buttonWidth),
                                      imageName: "tablecells.fill",
                                      labelText: "種目",
                                      backgroundColor: buttonBackgroundColor,
                                      foregroundColor: buttonForegroundColor)
        
        settingsButton = FooterButtonView(frame: CGRect(x: frame.size.width - buttonWidth - padding,
                                                        y: buttonY,
                                                        width: buttonWidth,
                                                        height: buttonWidth),
                                          imageName: "text.justify",
                                          labelText: "設定",
                                          backgroundColor: buttonBackgroundColor,
                                          foregroundColor: buttonForegroundColor)
        
        registerButton = FooterButton(frame: CGRect(x: center.x - buttonWidth/2,
                                                    y: lineWidth * 2,
                                                    width: buttonWidth,
                                                    height: buttonWidth),
                                      imageName: "plus",
                                      backgroundColor: mainBackgroundColor,
                                      foregroundColor: mainForegroundColor)
    
        addSubview(backgroundView!)
        addSubview(homeButton!)
        addSubview(recordButton!)
        addSubview(menuButton!)
        addSubview(settingsButton!)
        addSubview(registerButton!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - FooterBackgroundView

class FooterBackgroundView: UIView {
    
    var rectangleBackgroundView: UIView?
    var roundBackgroundView: UIView?
    var rectangleForegroundView: UIView?
    var roundForegroundView: UIView?
    
    init(frame: CGRect, lineWidth: CGFloat, backgroundColor: UIColor, foregroundColor: UIColor) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        let backgroundRadius: CGFloat = 40
        let foregroundRadius: CGFloat = backgroundRadius - lineWidth
        
        rectangleBackgroundView = UIView(frame: CGRect(x: 0,
                                                       y: backgroundRadius - lineWidth,
                                                       width: frame.size.width,
                                                       height: frame.size.height))
        
        roundBackgroundView = UIView(frame: CGRect(x: center.x - backgroundRadius,
                                                   y: 0,
                                                   width: backgroundRadius * 2,
                                                   height: backgroundRadius * 2))
        
        rectangleForegroundView = UIView(frame: CGRect(x: 0,
                                                       y: backgroundRadius,
                                                       width: frame.size.width,
                                                       height: frame.size.height))
        
        roundForegroundView = UIView(frame: CGRect(x: center.x - foregroundRadius,
                                                   y: lineWidth,
                                                   width: foregroundRadius * 2,
                                                   height: foregroundRadius * 2))
        
        rectangleBackgroundView?.layer.backgroundColor = backgroundColor.cgColor
        roundBackgroundView?.layer.backgroundColor = backgroundColor.cgColor
        roundBackgroundView?.layer.cornerRadius = backgroundRadius
        rectangleForegroundView?.layer.backgroundColor = foregroundColor.cgColor
        roundForegroundView?.layer.backgroundColor = foregroundColor.cgColor
        roundForegroundView?.layer.cornerRadius = foregroundRadius
        
        addSubview(rectangleBackgroundView!)
        addSubview(roundBackgroundView!)
        addSubview(rectangleForegroundView!)
        addSubview(roundForegroundView!)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - FooterButtonView

class FooterButtonView: UIView {
    
    var button: FooterButton?
    var label: UILabel?
    
    init(frame: CGRect, imageName: String, labelText: String, backgroundColor: UIColor, foregroundColor: UIColor) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        clipsToBounds = true
        
        let labelWidth: CGFloat = 40
        let labelHeight: CGFloat = 14
        let magnification: CGFloat = 0.7 // ボタンイメージの拡大倍率
        let buttonImage = UIImage(systemName: imageName)?
            .resize(size: .init(width: frame.size.width * magnification,
                                height: frame.size.width * magnification))
        
        button = FooterButton(frame: CGRect(x: 0,
                                            y: 0,
                                            width: frame.size.width,
                                            height: frame.size.height - labelHeight))
        
//        var config = UIButton.Configuration.plain()
//        config.image = buttonImage
//        config.imagePlacement = .top
//        config.baseForegroundColor = .orange
//        config.baseBackgroundColor = .orange
//        config.title = labelText
//        config.titleAlignment = .center
//        config.title.
//        button?.configuration = config
        
        button?.setImage(buttonImage, for: .normal)
        button?.configuration = .plain()
        button?.tintColor = foregroundColor
        button?.layer.backgroundColor = backgroundColor.cgColor

        label = UILabel(frame: CGRect(x: button!.center.x - labelWidth / 2,
                                      y: (button?.frame.maxY)!,
                                      width: labelWidth,
                                      height: labelHeight))
        label?.text = labelText
        label?.textColor = foregroundColor
        label?.backgroundColor = backgroundColor
        label?.textAlignment = .center
        label?.font = UIFont.systemFont(ofSize: 11)
        
        addSubview(button!)
        addSubview(label!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - FooterButton

class FooterButton: UIButton {
    let magnification: CGFloat = 0.92 // ボタンアニメーションの縮小倍率
    
    //ボタンを押しているときに縮小拡大するアニメーション
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: []) { [self] in
                    self.transform = .init(scaleX: magnification, y: magnification)
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
        
    }
    
    init(frame: CGRect, imageName: String, backgroundColor: UIColor, foregroundColor: UIColor) {
        super.init(frame: frame)
        
        let buttonRadius = frame.size.width/2
        
        self.backgroundColor = backgroundColor
        self.setImage(UIImage(systemName: imageName), for: .normal)
        self.tintColor = foregroundColor
        self.layer.cornerRadius = buttonRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
