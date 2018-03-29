//
//  ListSelectedViewModel.swift
//  MogoAirport
//
//  Created by luhao on 29/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa
import RxSwift

class ListSelectedViewModel {

    let name: String
    let options: BehaviorSubject<[String]>
    
    init(name aName: String, options list: [String]) {
        name = aName
        options = BehaviorSubject(value: list)
    }
}
