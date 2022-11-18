//
//  TotalVolumeView.swift
//  TrainingLogApp
//
//  Created by 田原葉 on 2022/11/16.
//

import UIKit
import RxSwift
import RxCocoa

class TotalVolumeView: UIView, UITextFieldDelegate {
    
    private let disposeBag = DisposeBag()
    var menuViewModel: WorkoutMenuViewModel?
    var recordViewModel: WorkoutRecordViewModel?
    var targetPartTextField: UITextField?
    var totalVolumeLabel: UILabel?
    var backgroundView: UIView?
    var addString: String?
    
    init(frame: CGRect, menuViewModel: WorkoutMenuViewModel, recordViewModel: WorkoutRecordViewModel) {
        super.init(frame: frame)
        self.menuViewModel = menuViewModel
        self.recordViewModel = recordViewModel
        
        let bacgroundColor = UIColor.darkGray
        let textColor = UIColor.white.withAlphaComponent(0.95)
        let borderColor = UIColor.orange
        addString = "の総ボリューム"
        
        self.backgroundColor = borderColor
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = bacgroundColor
        
        targetPartTextField = UITextField()
        targetPartTextField?.text = "すべて" + addString!
        targetPartTextField?.textColor = textColor
        targetPartTextField?.textAlignment = .center
        targetPartTextField?.font = UIFont.systemFont(ofSize: 14)
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        targetPartTextField!.inputView = picker
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: frame.width, height: 30)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let buttonItem = UIBarButtonItem(title: "決定",
                                         style: .done,
                                         target: self,
                                         action: #selector(donePicker))
        toolBar.setItems([space, buttonItem], animated: true)
        targetPartTextField!.inputAccessoryView = toolBar
        targetPartTextField!.delegate = self
        
        totalVolumeLabel = UILabel()
        totalVolumeLabel?.text = "0.0 KG"
        totalVolumeLabel?.textColor = textColor
        totalVolumeLabel?.textAlignment = .center
        totalVolumeLabel?.font = UIFont.systemFont(ofSize: 14)
        
        addSubview(backgroundView!)
        addSubview(targetPartTextField!)
        addSubview(totalVolumeLabel!)
        
        setupBinding()
    }
    
    private func setupBinding() {
        
        recordViewModel?.currentDate.asDriver(onErrorJustReturn: Date()).drive(onNext: { [weak self] date in
            self?.targetPartTextField?.text = "すべて" + (self?.addString!)!
            self?.totalVolumeLabel?.text = (self?.recordViewModel?.returnItemsAndVolume(target: (self?.targetPartTextField?.text)!, addstring: (self?.addString)!))!.description + " KG"
            
        }).disposed(by: disposeBag)
        
        targetPartTextField?.rx.text.asDriver().drive(onNext: { [weak self] target in
            
            self?.totalVolumeLabel?.text = (self?.recordViewModel?.returnItemsAndVolume(target: (self?.targetPartTextField?.text)!, addstring: (self?.addString)!))!.description + " KG"
            
        }).disposed(by: disposeBag)
    }
    
    @objc func donePicker() {
        targetPartTextField!.resignFirstResponder()
    }
    
    override func layoutSubviews() {
        let borderWidth: CGFloat = 4
        let verticalPadding: CGFloat = 2
        let horizontalPadding: CGFloat = 20
        let height: CGFloat = 26
        
        
        targetPartTextField?.frame = CGRect(x: horizontalPadding,
                                            y: verticalPadding,
                                            width: 200,
                                            height: height)
        totalVolumeLabel?.frame = CGRect(x: frame.maxX - horizontalPadding - 200,
                                         y: verticalPadding,
                                         width: 200,
                                         height: height)
        backgroundView?.frame = CGRect(x: 0,
                                       y: 0,
                                       width: frame.size.width,
                                       height: frame.size.height - borderWidth)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension TotalVolumeView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (menuViewModel?.workoutMenuArray.count)! + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "すべて"
        } else {
            return menuViewModel?.workoutMenuArray[row - 1].targetPart
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            targetPartTextField!.text = "すべて" + addString!
            
        } else {
            targetPartTextField!.text = (menuViewModel?.workoutMenuArray[row - 1].targetPart)! + addString!

        }
        
    }
}

