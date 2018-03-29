//
//  NSViewDispose.swift
//  MogoAirport
//
//  Created by luhao on 22/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Foundation
import RxSwift

private var disposeBagMark: Void?

extension Reactive where Base: NSObject {
    
    public var disposeBag: DisposeBag {
        get {
            if let dis = objc_getAssociatedObject(self, &disposeBagMark) as? DisposeBag {
                return dis
            } else {
                let dis = DisposeBag()
                objc_setAssociatedObject(self, &disposeBagMark, dis, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
                return dis
            }
        }
    }
}
