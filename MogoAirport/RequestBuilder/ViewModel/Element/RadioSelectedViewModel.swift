//
//  RadioSelectedViewModel.swift
//  MogoAirport
//
//  Created by luhao on 06/04/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

public final class RadioSelectedViewModel: NSObject, ElementViewModelProtocol {
    
    public var uiItem: UIConfigerItem
    
    let optionItems: BehaviorSubject<[String]>
    
    required public init(_ configer: UIConfigerItem) {
        uiItem = configer
        optionItems = BehaviorSubject(value: configer.candidate)
    }
}
