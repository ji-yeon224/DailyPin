//
//  InfoViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/01.
//

import UIKit


final class InfoViewController: BaseViewController {
    
    private let mainView = InfoView()
    let viewModel = InfoViewModel()
    private let repository = PlaceRepository()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
        mainView.updateSnapShot()
    }
    
    override func configureUI() {
        mainView.addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    }
    
    @objc private func addButtonClicked() {

        
        let vc = RecordViewController()
        vc.location = viewModel.place.value
        vc.editMode = true
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        present(nav, animated: true)
        
    }
    
    private func bindData() {
        
        viewModel.place.bind { data in
            guard let place = data else {
                self.showOKAlert(title: "", message: InvalidError.noExistData.localizedDescription) {
                    self.dismiss(animated: true)
                }
                
                return
            }
            self.mainView.titleLabel.text = place.displayName.placeName
            self.mainView.addressLabel.text = place.formattedAddress
        }
        
    }
    
    
   
    
    
}
