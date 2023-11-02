//
//  PlaceListViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/22.
//

import UIKit

final class PlaceListViewController: BaseViewController {
    
    let mainView = PlaceListView()
    private let viewModel = PlaceListViewModel()
    
    var placeListDelegate: PlaceListProtocol?
    
    override func loadView() {
        self.view = mainView
        mainView.collectionViewDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllPlaceData()
    }
    
    override func configureUI() {
        super.configureUI()
        
        
    }
    
    private func bindData() {
        
        viewModel.placeList.bind { data in
            
            if data.count == 0 {
                self.mainView.setPlaceHolder(false)
            } else {
                self.mainView.setPlaceHolder(true)
            }
            self.updateSnapShot()
        }
    }
    
    private func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, Place>()
        snapShot.appendSections([0])
        snapShot.appendItems(viewModel.placeList.value)
        mainView.dataSource.apply(snapShot)
    }
}

extension PlaceListViewController: PlaceCollectionViewProtocol {
    
    func didSelectPlaceItem(item: Place?) {
        guard let item = item else {
            showToastMessage(message: "toast_errorAlert".localized())
            return
        }
        placeListDelegate?.setPlaceLoaction(data: item)
        dismiss(animated: true)
        
        
    }
}
