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
        panel.canChooseFiles = false
        openPanel(canChooseDirectories: true, handle)
    }
    
    func openFile(_ handle: @escaping (URL) -> Void) {
        panel.canChooseFiles = true
        openPanel(canChooseDirectories: false, handle)
    }
    
    private func openPanel(canChooseDirectories: Bool, _ handle: @escaping (URL) -> Void) {
        
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = canChooseDirectories
        panel.begin { [weak panel] (result) in
            guard let `panel` = panel else { return }
            
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                guard let location = panel.url else { return }
                handle(location)
            }
        }
    }
}
