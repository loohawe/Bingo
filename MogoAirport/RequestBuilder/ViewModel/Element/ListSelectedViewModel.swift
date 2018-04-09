//
//  ListSelectedViewModel.swift
//  MogoAirport
//
//  Created by luhao on 29/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class ListSelectedViewModel: NSObject, ElementViewModelProtocol {

    var name: String {
        return uiItem.name
    }
    let options: BehaviorSubject<[String]>
    
    var uiItem: UIConfigerItem
    
    required init(_ configer: UIConfigerItem) {
        uiItem = configer
        options = BehaviorSubject(value: configer.candidate)
    }
}

extension Reactive where Base == ListSelectedViewModel {
    var value: Binder<String> {
        return Binder(base, binding: { (base, valueStr) in
            base.uiItem.value = valueStr
        })
    }
}
