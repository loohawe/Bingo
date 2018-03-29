//
//  AlertService.swift
//  MogoAirport
//
//  Created by luhao on 21/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Foundation
import Cocoa

struct AlertService {
    
    static func showAlert(inView view: NSView, massage: String, okButtonTitle: String, completionHandler: ((NSApplication.ModalResponse) -> Swift.Void)? = nil) {
        
        guard let window = view.window else {
            return
        }
        let alert = NSAlert()
        alert.addButton(withTitle: okButtonTitle)
        alert.messageText = massage
        alert.alertStyle = .warning
        alert.beginSheetModal(for: window, completionHandler: completionHandler)
    }
    
}
