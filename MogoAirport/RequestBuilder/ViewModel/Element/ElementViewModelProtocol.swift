//
//  ElementViewModelProtocol.swift
//  MogoAirport
//
//  Created by luhao on 26/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

public protocol ElementViewModelProtocol: NSObjectProtocol {
    
    var uiItem: UIConfigerItem { get set }
    init(_ configer: UIConfigerItem)
}

extension Reactive where Base: ElementViewModelProtocol {
     
    public var stringValue: Binder<String> {
        return Binder(base, binding: { (base, confValue) in
            base.uiItem.value = confValue
        })
    }
    
    public var mapValue: Binder<[String: Any]> {
        return Binder(base, binding: { (base, value) in
            base.uiItem.value = value
        })
    }
}
