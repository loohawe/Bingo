//
//  ParametersViewModel.swift
//  MogoAirport
//
//  Created by luhao on 06/04/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa

public final class ParametersViewModel: NSObject, ElementViewModelProtocol {

    public var uiItem: UIConfigerItem
    
    required public init(_ configer: UIConfigerItem) {
        uiItem = configer
    }
}
