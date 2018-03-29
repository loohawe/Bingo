//
//  StoreServices.swift
//  MogoAirport
//
//  Created by luhao on 22/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Foundation

class StoreService {
    
    private let userDef: UserDefaults = UserDefaults.standard
    
    deinit {
        UserDefaults.standard.synchronize()
    }
    
    var ymlFilePath: URL? {
        get {
            return userDef.url(forKey: "ymlFilePath")
        }
        set {
            userDef.set(newValue, forKey: "ymlFilePath")
        }
    }
}
