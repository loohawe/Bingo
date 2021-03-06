//
//  ParamView.swift
//  MogoAirport
//
//  Created by luhao on 07/09/2017.
//  Copyright © 2017 luhao. All rights reserved.
//

import Cocoa
import RxSwift

class ParamView: BGView, XibLoadable {
    
    var paramEntity = ParamEntity(name: "param", type: .intType)
    public var closeSubject = PublishSubject<Void>()
    
    @IBOutlet weak var nameTextField: NSTextField! {
        didSet {
            nameTextField.delegate = self
        }
    }
    @IBOutlet weak var typePopUp: NSPopUpButton!
    
    override func awakeFromNib() {
        nameTextField.stringValue = paramEntity.name
        typePopUp.selectItem(at: convertTypeToIndex())
    }
    
    @IBAction func typeChangedAction(_ sender: NSPopUpButton) {
        paramEntity.type = convertStringToType()
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        closeSubject.onNext(())
    }
}

// MARK: Delegate
extension ParamView: NSTextFieldDelegate {
    override func controlTextDidChange(_ obj: Notification) {
        paramEntity.name = nameTextField.stringValue
    }
}

// MARK: Method Private
extension ParamView {
    
    func convertStringToType() -> ParamType {
        guard let typeStr = typePopUp.selectedItem?.title else {
            fatalError("")
        }
        switch typeStr {
        case "Int":
            return ParamType.intType
        case "String":
            return ParamType.stringType
        case "Dictionary":
            return ParamType.dictionaryType
        case "Array":
            return ParamType.arrayType
        default:
            return ParamType.intType
        }
    }
    
    func convertTypeToIndex() -> Int {
        switch paramEntity.type {
        case .intType:
            return 0
        case .stringType:
            return 1
        case .dictionaryType:
            return 2
        case .arrayType:
            return 3
        }
    }
}
