//
//  ElementViewModelProtocol.swift
//  MogoAirport
//
//  Created by luhao on 26/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa

public protocol ElementViewModelProtocol {
    
    var uiItem: UIConfigerItem { get set }
    init(_ configer: UIConfigerItem)
}
