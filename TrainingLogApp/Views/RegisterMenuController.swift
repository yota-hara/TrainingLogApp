//
//  RegisterMenuController.swift
//  ProgressLogRE
//
//  Created by 田原葉 on 2022/11/01.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterMenuController: UIViewController, ViewControllerDelegate {
    var recordForm: RecordFormView?
    
    
    // MARK: - Properties & UIParts
    
    var footer: PublicFooterView?
    var viewModel: FormValidateViewModel?
    private let disposeBag = DisposeBag()


    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        viewModel = ViewModel()
        
        footer = PublicFooterView()
        footerBind()
        view.addSubview(footer!)
        
        recordForm = RecordFormView()
        recordForm?.alpha = 0
        view.addSubview(recordForm!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        footer?.anchor(bottom: view.bottomAnchor, left: view.leftAnchor, width: view.frame.size.width, height: 100)
        recordForm?.anchor(top: view.topAnchor, centerX: view.centerXAnchor, width: view.frame.size.width-40, height: 400, topPadding: 100)
    }
    
    func setupBindings() {
        
        
    }
    
    func footerBind() {
        
        footer?.addWorkoutButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            switch self?.recordForm?.alpha {
            case 0:
                UIView.animate(withDuration: 0.7, delay: 0.1, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self?.recordForm?.alpha = 1
                })
                self?.footer?.addWorkoutButton.setImage(UIImage(systemName: "multiply"), for: .normal)
                self?.footer?.addWorkoutButton.backgroundColor = .systemMint
            case 1:
                UIView.animate(withDuration: 0.7, delay: 0.1, options: UIView.AnimationOptions.allowUserInteraction, animations: {
                    self?.recordForm?.alpha = 0
                })
                self?.footer?.addWorkoutButton.setImage(UIImage(systemName: "plus"), for: .normal)
                self?.footer?.addWorkoutButton.backgroundColor = .orange
            case .none:
                break
            case .some(_):
                break
            }
        }).disposed(by: disposeBag)
        
        footer?.homeButton.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let homeVC = HomeViewController()
            homeVC.modalPresentationStyle = .fullScreen
            homeVC.modalTransitionStyle = .crossDissolve
            self?.present(homeVC, animated: true)
        }).disposed(by: disposeBag)
        
        footer?.recordWorkoutButton.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let recordVC = RecordWorkoutController()
            recordVC.modalPresentationStyle = .fullScreen
            recordVC.modalTransitionStyle = .crossDissolve
            self?.present(recordVC, animated: true)
        }).disposed(by: disposeBag)
        
        footer?.registerMenuButton.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let registerVC = RegisterMenuController()
            registerVC.modalPresentationStyle = .fullScreen
            registerVC.modalTransitionStyle = .crossDissolve
            self?.present(registerVC, animated: true)
        }).disposed(by: disposeBag)
        
        footer?.settingsButton.button?.rx.tap.asDriver().drive(onNext: { [weak self] in
            let settingVC = SettingViewController()
            settingVC.modalPresentationStyle = .fullScreen
            settingVC.modalTransitionStyle = .crossDissolve
            self?.present(settingVC, animated: true)
        }).disposed(by: disposeBag)
    }
}
