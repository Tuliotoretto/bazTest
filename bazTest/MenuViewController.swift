//
//  MenuViewController.swift
//  bazTest
//
//  Created by Julian Garcia  on 16/06/23.
//

import UIKit

class MenuViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UINavigationController(rootViewController: ListViewController())
        let vc2 = UINavigationController(rootViewController: FavoritesViewController())
        
        vc1.title = "TV Shows"
        vc2.title = "Favorites"
        
        self.setViewControllers([vc1, vc2], animated: false)
    }
}
