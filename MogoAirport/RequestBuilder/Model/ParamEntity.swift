//
//  ParamEntity.swift
//  MogoAirport
//
//  Created by luhao on 07/09/2017.
//  Copyright © 2017 luhao. All rights reserved.
//

import Foundation

public enum ParamType: String {
    case intType = "Int"
    case stringType = "String"
    case dictionaryType = "[String: Any]"
    case arrayType = "[Any]"
}

public struct ParamEntity {
    var name: String
    var type: ParamType
}
