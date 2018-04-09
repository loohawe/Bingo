//
//  ChooseFileViewModel.swift
//  MogoAirport
//
//  Created by luhao on 26/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import RxSwift
import RxCocoa

public class ChooseFileViewModel: NSObject, ElementViewModelProtocol {
    
    public var uiItem: UIConfigerItem
    
    public required init(_ configer: UIConfigerItem) {
        uiItem = configer
    }
    
}

extension Reactive where Base == ChooseFileViewModel {
    
    public var value: Binder<String> {
        return Binder.init(base, binding: { (base, value) in
            base.uiItem.value = value
        })
    }
    
}

