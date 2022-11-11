//
//  WorkoutCell.swift
//  TrainingLogApp
//
//  Created by 田原葉 on 2022/11/10.
//

import UIKit

class WorkoutRecordCell: UITableViewCell {
    
    static let identifier = "WorkoutCell"
    
    private let view: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.orange.cgColor
        view.layer.backgroundColor = UIColor.white.cgColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let targetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.backgroundColor = UIColor.orange.cgColor
        label.layer.maskedCorners = [.layerMinXMinYCorner]
        return label
    }()
    
    private let workoutLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.orange.cgColor
        label.layer.backgroundColor = UIColor.white.cgColor
        label.layer.maskedCorners = [.layerMaxXMaxYCorner]
        return label
    }()
    
    private let weightByRepsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    private let volumeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    private let memoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.layer.cornerRadius = 8
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        addSubview(view)
        addSubview(targetLabel)
        addSubview(workoutLabel)
        addSubview(weightByRepsLabel)
        addSubview(volumeLabel)
        addSubview(memoLabel)
    }
    
    override func layoutSubviews() {
        view.anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, topPadding: 5, bottomPadding: 5, leftPadding: 20, rightPadding: 20)
        targetLabel.anchor(top: view.topAnchor, left: view.leftAnchor, right: centerXAnchor, height: 18, rightPadding: -20)
        workoutLabel.anchor(top: targetLabel.bottomAnchor, left: view.leftAnchor, right: targetLabel.rightAnchor, height: 20)
        weightByRepsLabel.anchor(top: view.topAnchor, left: targetLabel.rightAnchor, right: view.rightAnchor, height: 16, topPadding: 2)
        volumeLabel.anchor(top: weightByRepsLabel.bottomAnchor, left: targetLabel.rightAnchor, right: view.rightAnchor, height: 16, topPadding: 2)
        memoLabel.anchor(top: volumeLabel.bottomAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topPadding: 5, bottomPadding: 5, leftPadding: 5, rightPadding: 5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: WorkoutRecordCellViewModel) {
        let workoutObject = viewModel.workoutObject
        targetLabel.text = workoutObject.targetPart
        workoutLabel.text = workoutObject.workoutName
        weightByRepsLabel.text = workoutObject.weight.description + " KG × " + workoutObject.reps.description + " 回"
        volumeLabel.text = "ボリューム： " + workoutObject.volume.description + " KG"
        memoLabel.text = workoutObject.memo
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        targetLabel.text = ""
        workoutLabel.text = ""
        weightByRepsLabel.text = ""
        volumeLabel.text = ""
        memoLabel.text = ""
    }
}
