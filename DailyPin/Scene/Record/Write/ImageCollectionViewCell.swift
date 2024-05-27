//
//  ImageCollectionViewCell.swift
//  DailyPin
//
//  Created by 김지연 on 3/14/24.
//


import UIKit
import SnapKit
import RxSwift

final class ImageCollectionViewCell: BaseCollectionViewCell {
    
    static let identifier = "ImageCollectionViewCell"
    
    private let uiview = UIView()
    var disposeBag = DisposeBag()
    
    let imageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    
    let cancelButton = CircleButton(image: Constants.Image.xmarkCircle).then {
        $0.tintColor = Constants.Color.basicText
        $0.backgroundColor = Constants.Color.background
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        
        disposeBag = DisposeBag()
    }
    
    override func configureUI() {
        contentView.addSubview(uiview)
        contentView.addSubview(imageView)
        contentView.addSubview(cancelButton)
    }
    
    override func setConstraints() {
        
        uiview.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
            
        }
        imageView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.9)
            make.height.equalTo(imageView.snp.width)
        }
        cancelButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(contentView)
            make.width.equalTo(contentView).multipliedBy(0.3)
            make.height.equalTo(cancelButton.snp.width)
        }
        
    }
    
    
}
