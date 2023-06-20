//
//  UIAlertController+CustomAlerts.swift
//  bazTest
//
//  Created by Julian Garcia  on 17/06/23.
//

import UIKit

extension UIAlertController {
    static func deleteAlert(title: String?, deleteAction: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            deleteAction?(action)
        }))
        
        return ac
    }
    
    static func errorAlert(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let ac = UIAlertController(
            title: "Oops, algo salió mal!",
            message: "Hubo un problema al guardar/borrar este show de TV. ¿Quieres intentar nuevamente?",
            preferredStyle: .alert
        )
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        ac.addAction(UIAlertAction(title: "Try Again", style: .destructive, handler: { action in
            handler?(action)
        }))
        
        return ac
    }
    
    static func connectionAlert(handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let ac = UIAlertController(
            title: "Oops, algo salió mal!",
            message: "Ocurrió un error al consultar el servicio. ¿Quieres intentar nuevamente?",
            preferredStyle: .alert
        )
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        ac.addAction(UIAlertAction(title: "Try Again", style: .destructive, handler: { action in
            handler?(action)
        }))
        
        return ac
    }
}

