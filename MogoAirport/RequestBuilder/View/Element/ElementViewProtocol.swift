//
//  ElementViewProtocol.swift
//  MogoAirport
//
//  Created by luhao on 05/04/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Foundation
import Cocoa
import RxSwift
import RxCocoa

internal protocol ElementViewProtocol: NSObjectProtocol {
    
    var nameLabel: NSTextField! { get set }
    var value: Any? { get }
    func emptyValue()
}

extension Reactive where Base: ElementViewProtocol{
    
    internal var name: Binder<String> {
        return Binder(base, binding: { (base, value) in
            base.nameLabel.stringValue = value
        })
    }
}
