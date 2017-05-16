//
//  AlertHelper.swift
//  Running Pace Calculator
//
//  Created by Luís Machado on 16/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

class AlertHelper {
    
    static func displayAlert(title: String, message: String, displayTo: UIViewController, completion: @escaping (UIAlertAction) -> Void = { _ in return }) {
        
        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: completion))
        
        displayTo.present(alert, animated: true, completion: nil)
        
    }
    
    
    static func displayAlertCancel(title: String, message: String, displayTo: UIViewController, okCallback: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: okCallback))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        displayTo.present(alert, animated: true, completion: nil)
        
    }
    
}
