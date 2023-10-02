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
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    private func bindData() {
        
        viewModel.place.bind { data in
            guard let place = data else {
                // 얼럿 띄우고 싶은데..
                self.dismiss(animated: true)
                return
            }
            self.mainView.titleLabel.text = place.displayName.text
        }
        
    }
    
    
   
    
    
}
