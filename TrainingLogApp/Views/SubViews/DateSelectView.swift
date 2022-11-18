//
//  DateSelectView.swift
//  TrainingLogApp
//
//  Created by 田原葉 on 2022/11/14.
//

import UIKit
import RxSwift
import RxCocoa

class DateSelectView: UIView {
    
    let disposeBag = DisposeBag()
    private var recordViewModel: WorkoutRecordViewModel?
    var backgroundView: UIView?
    
    var dateTextField: UITextField?
    var nextButton: UIButton?
    var prevButton: UIButton?
    var datePicker: UIDatePicker?
    
    init(frame: CGRect, recordViewModel: WorkoutRecordViewModel) {
        super.init(frame: frame)
        
        self.recordViewModel = recordViewModel
        
        let cornerRadius: CGFloat = 8
        
        let buttonBackgroundColor = UIColor.orange
        let buttonTitleColor = UIColor.white

        let backgroundColor = buttonTitleColor // viewの背景カラー
        let lineColor = buttonBackgroundColor // viewの下線カラー
        
        let dateStringColor = UIColor.darkGray
        
        self.backgroundColor = lineColor
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = backgroundColor
        
        dateTextField = UITextField()
        dateTextField?.text = DateUtils.toStringFromDate(date: Date())
        dateTextField?.textColor = dateStringColor
        dateTextField?.textAlignment = .center
        dateTextField?.font = UIFont.boldSystemFont(ofSize: 20)
        
        datePicker = createDatePicker()
        
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
        addSubview(dateTextField!)
        addSubview(nextButton!)
        addSubview(prevButton!)
        
        recordViewModel.recordFormApear.asDriver().drive(onNext: { [weak self] apear in
            self?.dateTextField?.isUserInteractionEnabled = !apear
            self?.nextButton?.isUserInteractionEnabled = !apear
            self?.prevButton?.isUserInteractionEnabled = !apear

        }).disposed(by: disposeBag)
        
        setupButtonAction()
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
        
        dateTextField?.frame = CGRect(x: center.x - dateLabelWidth / 2,
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
    
    private func createDatePicker() -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.timeZone = NSTimeZone.local
        picker.locale = Locale.current
        picker.preferredDatePickerStyle = .wheels
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(title: "決定", style: .done, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        
        dateTextField?.inputView = picker
        dateTextField?.inputAccessoryView = toolbar

        picker.rx.value.asDriver().drive(onNext: { [weak self] date  in
            self?.dateTextField?.text! = DateUtils.toStringFromDate(date: date)
            self?.recordViewModel?.dateUpdate(date: date)
        }).disposed(by: disposeBag)
        
        return picker
    }
    
    @objc func done() {
        dateTextField!.resignFirstResponder()
    }
    
    private func setupButtonAction() {
        nextButton?.rx.tap.asDriver().drive(onNext: { [weak self] in
                
                let dateString = self?.dateTextField?.text
                let date = DateUtils.toDateFromString(string: dateString!)
                let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                self?.recordViewModel?.dateUpdate(date: newDate)
        }).disposed(by: disposeBag)
        
        prevButton?.rx.tap.asDriver().drive(onNext: { [weak self] in

            let dateString = self?.dateTextField?.text
            let date = DateUtils.toDateFromString(string: dateString!)
            let newDate = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            self?.recordViewModel?.dateUpdate(date: newDate)
        }).disposed(by: disposeBag)
    }
}

