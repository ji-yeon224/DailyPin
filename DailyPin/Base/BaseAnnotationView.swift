//
//  BaseAnnotationView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/09.
//

import Foundation
import MapKit

class BaseAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configUI()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() { }
    
    func setConstraints() { }
   
    
    
}
