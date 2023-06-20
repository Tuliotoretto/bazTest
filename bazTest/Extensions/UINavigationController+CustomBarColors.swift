//
//  navigationController-CustomBarColors.swift
//  bazTest
//
//  Created by Julian Garcia  on 17/06/23.
//

import UIKit

extension UINavigationController {
    public func customBarColors(tint: UIColor, background: UIColor) {
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.isTranslucent = false
        
        self.navigationBar.largeTitleTextAttributes = [.foregroundColor: tint]
        self.navigationBar.titleTextAttributes = [.foregroundColor: tint]
        
        self.view.backgroundColor = background
        self.navigationBar.backgroundColor = background
        self.navigationBar.barTintColor = background
        
        self.navigationBar.tintColor = tint
    }
}
