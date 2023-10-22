//
//  PlaceListViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/22.
//

import UIKit

final class PlaceListViewController: BaseViewController {
    
    private let mainView = PlaceListView()
    let viewModel = PlaceListViewModel()
    
    var placeListDelegate: PlaceListProtocol?
    
    override func loadView() {
        self.view = mainView
        mainView.collectionViewDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureUI() {
        super.configureUI()
        viewModel.getAllPlaceData()
        bindData()
    }
    
    func bindData() {
        viewModel.placeList.bind { data in
            self.updateSnapShot()
        }
    }
    
    func updateSnapShot() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, Place>()
        snapShot.appendSections([0])
        guard !viewModel.placeList.value.isEmpty else { return }
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
