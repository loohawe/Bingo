//
//  ChooseFileView.swift
//  MogoAirport
//
//  Created by luhao on 20/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

extension ChooseFileView: XibLoadable {
    
    static public func setup(_ view: ChooseFileView) {
        
    }
    
}

public class ChooseFileView: BGView {
    
    public var name: String?
    public var filePath: BehaviorSubject<URL?> = BehaviorSubject(value: nil)

    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var fileButton: NSButton! {
        didSet {
            filePath
                .map { String($0?.absoluteString.suffix(26) ?? "请选择工程目录")}
                .subscribe(onNext: { [weak self] (location) in
                    self?.fileButton.title = location
                })
                .disposed(by: rxDisposeBag)
        }
    }
    
    private lazy var panelSer: OpenPanelService = OpenPanelService()
    
    override public func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override public var fittingSize: NSSize {
        let size = super.fittingSize
        return NSSize(width: size.width, height: 45.0)
    }
    
    @IBAction public func fileBottonAction(_ sender: NSButton) {
        panelSer.openDirectory { [weak self] (url) in
            self?.filePath.onNext(url)
        }
    }
}

extension ChooseFileView: ElementViewProtocol {
    
    var value: Any? {
        if let urlOp = try? filePath.value(),
            let url = urlOp {
            return url
        }
        return nil
    }
    
    func emptyValue() {
        filePath.onNext(nil)
    }
}

extension Reactive where Base == ChooseFileView {
    
    var name: Binder<String> {
        return Binder.init(base, binding: { (base, value) in
            base.name = value
            base.nameLabel.stringValue = value
        })
    }
    
}
