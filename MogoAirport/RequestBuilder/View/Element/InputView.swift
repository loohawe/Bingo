//
//  InputView.swift
//  MogoAirport
//
//  Created by luhao on 02/04/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa
import RxCocoa
import RxSwift

public final class InputView: BGView, XibLoadable {

    public lazy var inputValue: BehaviorSubject = BehaviorSubject(value: inputField.stringValue)
    
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var inputField: NSTextField!
    
    override public func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override public var fittingSize: NSSize {
        let size = super.fittingSize
        return NSSize(width: size.width, height: 55.0)
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        inputField.delegate = self
    }
    
}

extension InputView: ElementViewProtocol {
    
    var value: Any? {
        return inputField.stringValue
    }
    
    func emptyValue() {
        inputValue.onNext("")
        inputField.stringValue = ""
    }
}

extension InputView: NSTextFieldDelegate {
    
    public override func controlTextDidChange(_ obj: Notification) {
        //print("###\(inputField.stringValue)")
        inputValue.onNext(inputField.stringValue)
    }
}

extension Reactive where Base == InputView {
    
    var name: Binder<String> {
        return Binder(base, binding: { (base, value) in
            base.nameLabel.stringValue = value
        })
    }
}
