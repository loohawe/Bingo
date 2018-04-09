//
//  NSViewDispose.swift
//  MogoAirport
//
//  Created by luhao on 22/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Foundation
import RxSwift

private var disposeBagMark: UInt8 = 0

extension NSObject {
    
    public var rxDisposeBag: DisposeBag {
        get {
            if let dis = objc_getAssociatedObject(self, &disposeBagMark) as? DisposeBag {
                return dis
            } else {
                let dis = DisposeBag()
                objc_setAssociatedObject(self, &disposeBagMark, dis, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return dis
            }
        }
    }
}
