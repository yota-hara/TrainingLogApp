//
//  BaseViewController.swift
//  TrainingLogApp
//
//  Created by 田原葉 on 2022/11/09.
//


import UIKit
import RxSwift
import RxCocoa
import RealmSwift

protocol parentViewControllerPresentable: AnyObject {
    var recordForm: RecordFormView? { get }
    var footer: TabButtonFooterView? { get }
    var parentCenter: CGPoint? { get }
}

class BaseViewController: UIViewController, UITextFieldDelegate, parentViewControllerPresentable {
    
    // MARK: - Properties & UIParts
    
    var recordForm: RecordFormView?
    var footer: TabButtonFooterView?
    var parentCenter: CGPoint?
    private var vcView: UIView?
    private var childVC: UIViewController?
    
    private var validationViewModel: FormValidateViewModel?
    private var menuViewModel: WorkoutMenuViewModel?
    private var recordViewModel: WorkoutRecordViewModel?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuViewModel = WorkoutMenuViewModel()
        recordViewModel = WorkoutRecordViewModel(menuArray: menuViewModel!.workoutMenuArray)
        validationViewModel = FormValidateViewModel()
        parentCenter = view.center
        
        vcView = UIView()
        view.addSubview(vcView!)
        
        setupChildVC()
        setupFooter()
        setupRecordForm()
        setupKeyboardAndView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        vcView!.anchor(top: view.topAnchor, bottom: footer?.topAnchor, left: view.leftAnchor, right: view.rightAnchor, bottomPadding: -40)
        footer?.anchor(bottom: view.bottomAnchor, left: view.leftAnchor, width: view.frame.size.width, height: 130)
        recordForm?.anchor(centerY: view.centerYAnchor, centerX: view.centerXAnchor, width: view.frame.size.width-40, height: 400)
    }
    
    // MARK: - Setup & Bindings
    
    private func setupChildVC() {
        let homeVC = HomeViewController()
        homeVC.view.frame = vcView!.frame
        homeVC.view.autoresizingMask = []
        addChild(homeVC)
        vcView?.addSubview(homeVC.view)
        homeVC.didMove(toParent: self)
        childVC = homeVC
        
        let recordVC = WorkoutRecordViewController(parent: self, recordViewModel: recordViewModel!)
        recordVC.view.frame = vcView!.frame
        
        let menuVC = WorkoutMenuViewController()
        menuVC.view.frame = vcView!.frame
        
        let settingVC = SettingViewController()
        settingVC.view.frame = vcView!.frame
    }
    
    private func setupKeyboardAndView() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe({ notification in
                if let element = notification.element {
                    self.keyboardwillShow(element)
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe({ notification in
                if let element = notification.element {
                    self.keyboardWillHide(element)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func keyboardwillShow(_ notification: Notification) {
        guard let rect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0,
                                              y:  -rect.size.height + 200)
            self.view.transform = transform
        }
    }
    
    private func keyboardWillHide(_ notification: Notification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval else { return }
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform.identity
        }
    }
    
    private func setupRecordForm() {
        recordForm = RecordFormView(frame: .zero,
                                    recordViewModel: recordViewModel!,
                                    menuViewModel: menuViewModel!)
        recordForm?.alpha = 0
        
        recordForm?.registerButton?.rx.tap.asDriver().drive(onNext: { [weak self] in
            if self?.recordForm?.alpha != 0 {
                self?.recordFormDisappear()
            }
        }).disposed(by: disposeBag)
        
        view.addSubview(recordForm!)
    }
    
    private func recordFormDisappear() {
        UIView.animate(withDuration: 0.4, delay: 0.1, options: UIView.AnimationOptions.allowUserInteraction, animations: {
            self.recordForm?.alpha = 0
            self.footer?.registerButton!.setImage(UIImage(systemName: "plus"), for: .normal)
            self.footer?.registerButton!.backgroundColor = .orange
            self.recordViewModel?.recordFormApear.accept(false)
        })
    }
    
    private func setupFooter() {
        footer = TabButtonFooterView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 100))
        view.addSubview(footer!)
        footer?.registerButton!.rx.tap.asDriver().drive(onNext: { [weak self] in
            switch self?.recordForm?.alpha {
            case 0:
                UIView.animate(withDuration: 0.7, delay: 0.1, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self?.recordForm?.alpha = 1
                })
                self?.footer?.registerButton!.setImage(UIImage(systemName: "multiply"), for: .normal)
                self?.footer?.registerButton!.backgroundColor = .systemMint
                self?.recordViewModel?.recordFormApear.accept(true)
            case 1:
                UIView.animate(withDuration: 0.7, delay: 0.1, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self?.recordForm?.alpha = 0
                })
                self?.footer?.registerButton!.setImage(UIImage(systemName: "plus"), for: .normal)
                self?.footer?.registerButton!.backgroundColor = .orange
                self?.recordViewModel?.recordFormApear.accept(false)
            case .none:
                break
            case .some(_):
                break
            }
        }).disposed(by: disposeBag)
        
        footer?.homeButton!.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let homeVC = HomeViewController()
            if self?.childVC != homeVC {
                self?.childVC!.willMove(toParent: nil)
                self?.childVC!.view.removeFromSuperview()
                self?.childVC!.removeFromParent()
                self?.addChild(homeVC)
                self?.vcView!.addSubview(homeVC.view)
                homeVC.didMove(toParent: self)
                self?.childVC = homeVC
                self?.recordFormDisappear()
            }
        }).disposed(by: disposeBag)
        
        footer?.recordButton!.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let recordVC = WorkoutRecordViewController(parent: self!,
                                                       recordViewModel: (self?.recordViewModel)!)
            if self?.childVC != recordVC {
                self?.childVC!.willMove(toParent: nil)
                self?.childVC!.view.removeFromSuperview()
                self?.childVC!.removeFromParent()
                self?.addChild(recordVC)
                recordVC.view.frame = (self?.vcView!.frame)!
                recordVC.view.autoresizingMask = []
                self?.vcView!.addSubview(recordVC.view)
                recordVC.didMove(toParent: self)
                self?.childVC = recordVC
                self?.recordFormDisappear()
            }
        }).disposed(by: disposeBag)
        
        footer?.menuButton!.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let menuVC = WorkoutMenuViewController()
            if self?.childVC != menuVC {
                self?.childVC!.willMove(toParent: nil)
                self?.childVC!.view.removeFromSuperview()
                self?.childVC!.removeFromParent()
                self?.addChild(menuVC)
                self?.vcView!.addSubview(menuVC.view)
                menuVC.didMove(toParent: self)
                self?.childVC = menuVC
                self?.recordFormDisappear()
            }
        }).disposed(by: disposeBag)
        
        footer?.settingsButton!.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let settingVC = SettingViewController()
            if self?.childVC != settingVC {
                self?.childVC!.willMove(toParent: nil)
                self?.childVC!.view.removeFromSuperview()
                self?.childVC!.removeFromParent()
                self?.addChild(settingVC)
                self?.vcView!.addSubview(settingVC.view)
                settingVC.didMove(toParent: self)
                self?.childVC = settingVC
                self?.recordFormDisappear()
            }
        }).disposed(by: disposeBag)
    }
    
    //MARK: - UITextFieldDelegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


