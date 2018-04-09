//
//  OutputView.swift
//  MogoAirport
//
//  Created by luhao on 07/04/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa
import ITProgressBar
import RxSwift
import RxCocoa
import PromiseKit

public class OutputView: BGView, XibLoadable {

    @IBOutlet weak var progressBar: ITProgressBar! {
        didSet {
            progressBar.borderWidth = 0.0
            progressBar.animates = false
        }
    }
    @IBOutlet weak var scrollView: BGScrollView!
    @IBOutlet var textView: NSTextView!
    
    override public func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override public var fittingSize: NSSize {
        let size = super.fittingSize
        return NSSize(width: size.width, height: 200.0)
    }
    
//    private var shell: Shell!
//    private var which: ShWhich!
    @IBAction func clearButtonAction(_ sender: NSButton) {
        textView.string = ""
        
        scrollTextFieldToBottom()
        
//        shell = Shell(command: "git --version")
//        shell.executeCommand { (result, error) in
//            print("###\(result)****\(error)")
//        }
        
//        which = ShWhich.init("gkhjgkgkhg")
//        which.executeCommand { (result, error) in
//            print("###\(result)****\(error)")
//        }
        
//        shell.execute()
//            .done { (result) in
//                print("###\(result)")
//            }
//            .catch { (error) in
//                
//            }
    }
}

// MARK: - Public method
extension OutputView {
    
    public func startLoading() {
        progressBar.animates = true
    }
    
    public func endLoading() {
        progressBar.animates = false
    }
    
    public func output(_ string: String) {
        textView.string = textView.string.appending("\n\(string)")
        
        scrollTextFieldToBottom()
    }
}

// MARK: - Private method
extension OutputView {
    
    private func scrollTextFieldToBottom() {
        if let rect = scrollView.documentView?.frame {
            /**
            print("\ndocument view size")
            print(rect)
            print(scrollView.contentSize)
            print(scrollView.contentView.frame)
            print(scrollView.verticalScroller?.floatValue)
            print("content size\n")**/
            scrollView.verticalScroller?.floatValue = 1.0
            scrollView.scroll(scrollView.contentView, to: NSPoint(x: 0, y: rect.maxY - scrollView.contentSize.height))
        }
    }
}

extension Reactive where Base == OutputView {
    
    var output: Binder<String> {
        return Binder(base, binding: { (base, value) in
            base.output(value)
        })
    }
}
