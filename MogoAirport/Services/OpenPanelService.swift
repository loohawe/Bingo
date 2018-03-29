//
//  OpenPannelService.swift
//  MogoAirport
//
//  Created by luhao on 22/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Foundation
import AppKit

class OpenPanelService {
    
    var panel: NSOpenPanel = NSOpenPanel()
    
    func openDirectory(_ handle: @escaping (URL) -> Void) {
        openPanel(canChooseDirectories: true, handle)
    }
    
    func openFile(_ handle: @escaping (URL) -> Void) {
        openPanel(canChooseDirectories: false, handle)
    }
    
    private func openPanel(canChooseDirectories: Bool, _ handle: @escaping (URL) -> Void) {
        
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = canChooseDirectories
        panel.canChooseFiles = true
        panel.begin { [weak panel, weak self] (result) in
            guard let `panel` = panel else { return }
            
            if result.rawValue == NSFileHandlingPanelOKButton {
                guard let location = panel.url else { return }
                handle(location)
            }
        }
    }
}
