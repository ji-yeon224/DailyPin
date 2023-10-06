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
        
    }
    
    override func configureUI() {
        mainView.addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
    }
    
    @objc private func addButtonClicked() {
        
        
//        guard let data = viewModel.place.value else {
//
//            // throw
//            return
//        }
//
//        // 저장 시 중복 검사 필요
//        if repository.isExistPlace(id: data.id) {
//            return
//        } else {
//            let place = Place(placeId: data.id, address: data.formattedAddress, placeName: data.displayName.placeName, latitude: data.location.latitude, longitude: data.location.longitude)
//
//
//
//            do {
//                try repository.createItem(place)
//                showToastMessage(message: "저장 성공")
//            } catch {
//                showToastMessage(message: "저장 실패")
//            }
//
//        }
        
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
                // 얼럿 띄우고 싶은데..
                self.dismiss(animated: true)
                return
            }
            self.mainView.titleLabel.text = place.displayName.placeName
            self.mainView.addressLabel.text = place.formattedAddress
        }
        
    }
    
    
   
    
    
}
