//
//  YamlLoadedService.swift
//  MogoAirport
//
//  Created by luhao on 20/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa
import Yaml

class YamlLoadedService {
    
    //public static let shared: YamlLoadedService = YamlLoadedService()
    var yamlValue: Yaml

    init(_ yamlContent: String) throws {
        yamlValue = try Yaml.load(yamlContent)
    }
    
}
