//
//  ViewEvent.swift
//  MogoAirport
//
//  Created by luhao on 09/09/2017.
//  Copyright © 2017 luhao. All rights reserved.
//

import Foundation
import Cocoa

extension NSView
{
    func subviewsEnable(_ enable: Bool)
    {
        let viewEnumerator = subviews.enumerated()
        viewEnumerator.forEach { (_, itemView) in
            if let itemControl = itemView as? NSControl {
                itemControl.isEnabled = enable
            }
            itemView.subviewsEnable(enable)
            itemView.display()
        }
    }
}
