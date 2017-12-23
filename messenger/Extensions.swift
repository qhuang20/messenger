//
//  Extensions.swift
//  messenger
//
//  Created by Qichen Huang on 2017-12-22.
//  Copyright © 2017 Qichen Huang. All rights reserved.
//
import UIKit

extension UIView {
    
    func addConstraintsWith(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

