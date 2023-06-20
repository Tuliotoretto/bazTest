//
//  UIView+showErrorAlert.swift
//  bazTest
//
//  Created by Julian Garcia  on 18/06/23.
//

import UIKit

extension UIViewController {
    func showErrorAlert(err: Error?) {
        if let err = err {
            let ac = UIAlertController.errorAlert()
            self.present(ac, animated: true)
        }
    }
}
