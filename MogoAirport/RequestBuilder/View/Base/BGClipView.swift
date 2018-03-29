//
//  BGClipView.swift
//  MogoAirport
//
//  Created by luhao on 22/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa

class BGClipView: NSClipView {
    
    override var isFlipped: Bool {
        return true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
