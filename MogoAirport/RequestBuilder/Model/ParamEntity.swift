//
//  ParamEntity.swift
//  MogoAirport
//
//  Created by luhao on 07/09/2017.
//  Copyright © 2017 luhao. All rights reserved.
//

import Foundation

enum ParamType
{
    case intType
    case stringType
    case dictionaryType
    case arrayType
}

struct ParamEntity
{
    var name: String
    var type: ParamType
}
