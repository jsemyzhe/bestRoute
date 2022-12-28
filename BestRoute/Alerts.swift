//
//  Alerts.swift
//  BestRoute
//
//  Created by Julia Semyzhenko on 21.12.2022.
//

import UIKit

extension UIViewController {
    func addAddressAlert(title: String, placeholder: String, completionHandler: @escaping  (String) -> Void) {
        let addAlert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let actionAdd = UIAlertAction(title: "Add", style: .default) { (handler) in
            let alertTextfield = addAlert.textFields?.first
            
            guard let text = alertTextfield?.text else { return }
            completionHandler(text)
        }
        addAlert.addTextField { (textfield) in
            textfield.placeholder = placeholder
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        addAlert.addAction(actionAdd)
        addAlert.addAction(actionCancel)
        present(addAlert, animated: true)
        
    }
    
    func errorAlert(title: String, message: String) {
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(okButton)
        present(alert, animated: true)
    }
}
