//
//  InputViewModel.swift
//  MogoAirport
//
//  Created by luhao on 05/04/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Foundation

public final class InputViewModel: NSObject, ElementViewModelProtocol {
    
    public var uiItem: UIConfigerItem
    
    required public init(_ configer: UIConfigerItem) {
        uiItem = configer
    }
}
