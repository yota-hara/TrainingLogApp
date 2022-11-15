//
//  WorkoutCell.swift
//  TrainingLogApp
//
//  Created by 田原葉 on 2022/11/10.
//

import UIKit

class WorkoutRecordCell: UITableViewCell {
    
    static let identifier = "WorkoutCell"
    
    var bacgroundView: CellBackgroundView?
    var targetLabel: CellLabel?
    var workoutLabel: CellLabel?
    var weightByRepsLabel: CellLabel?
    var volumeLabel: CellLabel?
    var memoImageView: CellMemoImageView?
    var memoTextLabel: CellLabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        let foregroundColor = UIColor.orange
        let backgroundColor = UIColor.white
        let textColor = UIColor.darkGray
        let memoTextColor = UIColor.systemTeal.withAlphaComponent(0.9)
        let borderWidth: CGFloat = 2
        let cornerRadius: CGFloat = 8
        
        bacgroundView = CellBackgroundView(frame: .zero,
                                           borderWidth: borderWidth,
                                           borderColor: foregroundColor,
                                           backgroundXColor: backgroundColor,
                                           cornerRadius: cornerRadius)

        targetLabel = CellLabel(frame: .zero,
                                borderWidth: borderWidth,
                                borderColor: foregroundColor,
                                textColor: backgroundColor,
                                backgroundColor: foregroundColor,
                                maskedCorners: [.layerMinXMinYCorner],
                                cornerRadius: cornerRadius)
        
        workoutLabel = CellLabel(frame: .zero,
                                 borderWidth: borderWidth,
                                 borderColor: foregroundColor,
                                 textColor: textColor,
                                 backgroundColor: backgroundColor,
                                 maskedCorners: [.layerMaxXMaxYCorner],
                                 cornerRadius: cornerRadius)
     
        weightByRepsLabel = CellLabel(frame: .zero,
                                      font: UIFont.systemFont(ofSize: 12),
                                      textColor: textColor)

        volumeLabel = CellLabel(frame: .zero,
                                font: UIFont.systemFont(ofSize: 12),
                                textColor: textColor)
        
        memoImageView = CellMemoImageView(frame: .zero,
                                          foregroundColor: foregroundColor)
        
        memoTextLabel = CellLabel(frame: .zero,
                                  font: UIFont.systemFont(ofSize: 11),
                                  textColor: memoTextColor,
                                  numberOfLines: 0,
                                  textAlignment: .left)

        addSubview(bacgroundView!)
        addSubview(targetLabel!)
        addSubview(workoutLabel!)
        addSubview(weightByRepsLabel!)
        addSubview(volumeLabel!)
        addSubview(memoImageView!)
        addSubview(memoTextLabel!)
    }
    
    override func layoutSubviews() {
                
        // bacgroundView
        let viewVerticalPadding: CGFloat = 20
        let viewHorizontalPadding: CGFloat = 5
        
        // targetLabel, workoutLabel
        let labelHeight: CGFloat = 18
        let labelHorizontalPadding: CGFloat = 20
        
        // weightByRepsLabel, volumeLabel
        let smallLabelHeight: CGFloat = 16
        let smallLabelVerticalPadding: CGFloat = 1
        
        // memoImageView
        let imageWidth: CGFloat = 30
        let imageHorizontalPadding: CGFloat = 5
        
        // memoTextLabel
        let memoPadding: CGFloat = 5
        
        bacgroundView!.anchor(top: topAnchor,
                     bottom: bottomAnchor,
                     left: leftAnchor,
                     right: rightAnchor,
                     topPadding: viewHorizontalPadding,
                     bottomPadding: viewHorizontalPadding,
                     leftPadding: viewVerticalPadding,
                     rightPadding: viewVerticalPadding)
        
        targetLabel!.anchor(top: bacgroundView!.topAnchor,
                            left: bacgroundView!.leftAnchor,
                            right: centerXAnchor,
                            height: labelHeight,
                            rightPadding: -labelHorizontalPadding)
        
        workoutLabel!.anchor(top: targetLabel!.bottomAnchor,
                             left: bacgroundView!.leftAnchor,
                             right: targetLabel!.rightAnchor,
                             height: labelHeight)
        
        weightByRepsLabel!.anchor(top: bacgroundView!.topAnchor,
                                  left: targetLabel!.rightAnchor,
                                  right: bacgroundView!.rightAnchor,
                                  height: smallLabelHeight,
                                  topPadding: smallLabelVerticalPadding)
        
        volumeLabel!.anchor(top: weightByRepsLabel!.bottomAnchor,
                            left: targetLabel!.rightAnchor,
                            right: bacgroundView!.rightAnchor,
                            height: smallLabelHeight,
                            topPadding: smallLabelVerticalPadding)
        
        memoImageView!.anchor(left: bacgroundView!.leftAnchor,
                              centerY: memoTextLabel?.centerYAnchor,
                              width: imageWidth,
                              height: imageWidth,
                              leftPadding: imageHorizontalPadding)
        
        memoTextLabel!.anchor(top: workoutLabel!.bottomAnchor,
                              bottom: bacgroundView!.bottomAnchor,
                              left: memoImageView!.rightAnchor,
                              right: bacgroundView!.rightAnchor,
                              topPadding: memoPadding,
                              bottomPadding: memoPadding,
                              leftPadding: memoPadding,
                              rightPadding: memoPadding)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: WorkoutRecordCellViewModel) {
        let workoutObject = viewModel.workoutObject
        targetLabel!.text = workoutObject.targetPart
        workoutLabel!.text = workoutObject.workoutName
        weightByRepsLabel!.text = workoutObject.weight.description + " KG × " + workoutObject.reps.description + " 回"
        volumeLabel!.text = "ボリューム： " + workoutObject.volume.description + " KG"
        memoTextLabel!.text = workoutObject.memo
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        targetLabel!.text = ""
        workoutLabel!.text = ""
        weightByRepsLabel!.text = ""
        volumeLabel!.text = ""
        memoTextLabel!.text = ""
    }
}

// MARK: - CellBackgroundView

class CellBackgroundView: UIView {
    
    init(frame: CGRect, borderWidth: CGFloat, borderColor: UIColor, backgroundXColor: UIColor, cornerRadius: CGFloat) {
        super.init(frame: frame)
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.layer.backgroundColor = backgroundXColor.cgColor
        self.layer.cornerRadius = cornerRadius
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CellLabel

class CellLabel: UILabel {

    init(frame: CGRect, borderWidth: CGFloat, borderColor: UIColor, textColor: UIColor, backgroundColor: UIColor, maskedCorners: CACornerMask, cornerRadius: CGFloat) {
        super.init(frame: frame)
                 
        self.font = UIFont.systemFont(ofSize: 16)
        self.textColor = textColor
        self.textAlignment = .center
        self.layer.backgroundColor = backgroundColor.cgColor
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = maskedCorners
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        
    }
    
    init(frame: CGRect, font: UIFont, textColor: UIColor, numberOfLines: Int = 1, textAlignment: NSTextAlignment = .center) {
        super.init(frame: frame)
                
        self.backgroundColor = .clear
        
        self.font = font
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.numberOfLines = numberOfLines
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CellMemoImageView

class CellMemoImageView: UIView {
    
    var imageView: UIImageView?
    
    init(frame: CGRect, foregroundColor: UIColor) {
        super.init(frame: frame)
        let backgroundColor = UIColor.clear
        self.backgroundColor = backgroundColor
        
        imageView = UIImageView()
        imageView?.image = UIImage(systemName: "square.and.pencil")
        imageView?.contentMode = .scaleAspectFit
        imageView?.tintColor = foregroundColor
        imageView?.backgroundColor = backgroundColor
        addSubview(imageView!)
    }
    
    override func layoutSubviews() {
        imageView?.frame = CGRect(x: 0,
                                  y: 0,
                                  width: frame.size.width,
                                  height: frame.size.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


