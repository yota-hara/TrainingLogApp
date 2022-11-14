//
//  DateSelectView.swift
//  TrainingLogApp
//
//  Created by 田原葉 on 2022/11/14.
//

import UIKit

class DateSelectView: UIView {
    
    var backgroundView: UIView?
    
    var dateLabel: UILabel?
    var nextButton: UIButton?
    var prevButton: UIButton?
    
    var dateText = DateUtils.toStringFromDate(date: Date())
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let cornerRadius: CGFloat = 8
        
        let buttonBackgroundColor = UIColor.orange
        let buttonTitleColor = UIColor.white

        let backgroundColor = buttonTitleColor // viewの背景カラー
        let lineColor = buttonBackgroundColor // viewの下線カラー
        
        let dateStringColor = UIColor.darkGray
        
        self.backgroundColor = lineColor
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = backgroundColor
        
        dateLabel = UILabel()
        dateLabel?.text = dateText
        dateLabel?.textColor = dateStringColor
        dateLabel?.textAlignment = .center
        dateLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        
        nextButton = UIButton()
        nextButton?.setTitle("翌日>", for: .normal)
        nextButton?.setTitleColor(buttonTitleColor, for: .normal)
        nextButton?.layer.cornerRadius = cornerRadius
        nextButton?.layer.backgroundColor = buttonBackgroundColor.cgColor
        
        prevButton = UIButton()
        prevButton?.setTitle("<前日", for: .normal)
        prevButton?.setTitleColor(buttonTitleColor, for: .normal)
        prevButton?.layer.cornerRadius = cornerRadius
        prevButton?.layer.backgroundColor = buttonBackgroundColor.cgColor
        
        addSubview(backgroundView!)
        addSubview(dateLabel!)
        addSubview(nextButton!)
        addSubview(prevButton!)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineWidth: CGFloat = 4

        let contentsY: CGFloat = safeAreaInsets.top + 10
        
        let dateLabelWidth: CGFloat = 200
        let dateLabelHeight: CGFloat = 30
        
        let buttonWidth: CGFloat = 60
        let buttonHeight: CGFloat = 25
        let buttonSidePadding: CGFloat = 20

        backgroundView?.frame = CGRect(x: 0,
                                       y: 0,
                                       width: frame.size.width,
                                       height: frame.size.height - lineWidth)
        
        dateLabel?.frame = CGRect(x: center.x - dateLabelWidth / 2,
                                  y: contentsY,
                                  width: dateLabelWidth,
                                  height: dateLabelHeight)
        
        nextButton?.frame = CGRect(x: frame.maxX - buttonWidth - buttonSidePadding,
                                   y: contentsY,
                                   width: buttonWidth,
                                   height: buttonHeight)
        
        prevButton?.frame = CGRect(x: buttonSidePadding,
                                   y: contentsY,
                                   width: buttonWidth,
                                   height: buttonHeight)


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
