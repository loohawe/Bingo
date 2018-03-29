//
//  BuilderViewController.swift
//  MogoAirport
//
//  Created by luhao on 06/09/2017.
//  Copyright © 2017 luhao. All rights reserved.
//

import Cocoa
import RxSwift
import SnapKit
import ITProgressBar

fileprivate let paramViewHeight: CGFloat = 36.0

class BuilderViewController: NSViewController {
    // MARK: Property Public
    
    @IBOutlet weak var locationButton: NSButton!
    @IBOutlet weak var hatNameTextField: NSTextField!
    
    @IBOutlet weak var requestFungiRadio: NSButton!
    @IBOutlet weak var requestMogoRadio: NSButton!
    
    @IBOutlet weak var fetcherPopup: NSPopUpButton!
    
    @IBOutlet weak var postRadio: NSButton!
    @IBOutlet weak var getRadio: NSButton!
    
    @IBOutlet weak var pathTextField: NSTextField!
    
    @IBOutlet weak var addParamButton: NSButton!
    @IBOutlet weak var clearParamButton: NSButton! {
        didSet {
            clearParamButton.isHidden = true
        }
    }
    @IBOutlet weak var paramScrollView: NSScrollView!
    
    @IBOutlet weak var outputTextField: NSTextField!
    @IBOutlet weak var resetButton: NSButton!
    @IBOutlet weak var binggoButton: NSButton!

    @IBOutlet weak var progressBar: ITProgressBar! {
        didSet {
            progressBar.borderWidth = 0.0
            progressBar.animates = false
        }
    }
    
    // MARK: Property Private
    
    fileprivate var viewModel: BuilderViewModel!
    fileprivate var disposeBag = DisposeBag()
    fileprivate var paramViews = [ParamView]() {
        didSet {
            updateClearParamButtonStatus()
        }
    }
    
    // MARK: Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = BuilderViewModel(entity: BuilderEntity(projectLocation:URL(string: "/user")!))
        view.subviewsEnable(false)
        locationButton.isEnabled = true
        
        bindModel()
    }
    
    override func viewWillLayout() {
        super.viewWillLayout()
        
        reLayoutParamView()
    }
    
}

// MARK: Actions

extension BuilderViewController {
    
    @IBAction func openPanelAction(_ sender: NSButton) {
        // self.view.subviewsEnable(true)
        viewModel.chooseProject {
            [weak self] (success, path) in
            guard let `self` = self else { return }
            
            if success {
                print(path)
                self.view.subviewsEnable(true)
            } else {
                self.viewModel.showStupidAlert(in: self.view)
            }
        }
    }
    
    @IBAction func addParametersAction(_ sender: NSButton) {
        let paramView = generatParamView()
        paramScrollView.contentView.addSubview(paramView)
        paramViews.append(paramView)
        reLayoutParamView()
    }
    
    @IBAction func radioButtonAction(_ sender: NSButton) {
        if sender == postRadio {
            getRadio.state = NSControl.StateValue.off
            postRadio.state = NSControl.StateValue.on
            viewModel.entity.method = .post
        }
        
        if sender == getRadio {
            getRadio.state = NSControl.StateValue.on
            postRadio.state = NSControl.StateValue.off
            viewModel.entity.method = .get
        }
    }
    
    @IBAction func generatorButtonAction(_ sender: NSButton) {
        view.subviewsEnable(false)
        progressBar.animates = true
        viewModel.generatorFiles()
        viewModel.excuteUpdateCommand() {
            [weak self]
            (output) in
            guard let `self` = self else {return}
            
            self.outputTextField.stringValue = output
            print("\(output)")
            self.progressBar.animates = false
            self.resetAllData()
            self.view.subviewsEnable(true)
        }
    }
    
    @IBAction func clearParamButtonAction(_ sender: NSButton) {
        clearParams()
    }
    
    @IBAction func requestTypeRadioAction(_ sender: NSButton) {
        if sender == requestFungiRadio {
            requestMogoRadio.state = NSControl.StateValue.off
            requestFungiRadio.state = NSControl.StateValue.on
            viewModel.entity.requestType = .fungi
        }
        
        if sender == requestMogoRadio {
            requestMogoRadio.state = NSControl.StateValue.on
            requestFungiRadio.state = NSControl.StateValue.off
            viewModel.entity.requestType = .mogo
        }
    }
    
    @IBAction func fetcherTypePopUpButtonAction(_ sender: NSPopUpButton) {
        guard let typeStr = sender.selectedItem?.title else {
            fatalError("")
        }
        
        viewModel.entity.responseFetcher = typeStr
    }
    
    @IBAction func resetButtonAction(_ sender: NSButton) {
        resetAllData()
    }
}

// MARK: Method Private

extension BuilderViewController {
    func bindModel() {
        viewModel.locSubject.subscribe { (event) in
            self.locationButton.title = event.element?.path ?? "Choose Project"
        }.addDisposableTo(disposeBag)
        
        hatNameTextField.delegate = viewModel
        pathTextField.delegate = viewModel
        
        viewModel.paramEntityList = {
            self.paramViews.map{ $0.paramEntity }
        }
    }
    
    func generatParamView() -> ParamView {
        
        var array: NSArray? = []
        
        if Bundle.main.loadNibNamed(NSNib.Name(rawValue: "ParamView"), owner: self, topLevelObjects: &array) {
            var pView: ParamView?
            if let `array` = array {
                array.forEach({ (item) in
                    if let paramView = item as? ParamView {
                        pView = paramView
                    }
                })
            }
            
            if let resultView = pView {
                
                resultView.closeSubject.subscribe {
                    [weak self, weak resultView](_) in
                    
                    guard let `self` = self else {return}
                    guard let `resultView` = resultView else {return}
                    
                    if let index = self.paramViews.index(of: resultView) {
                        self.paramViews.remove(at: index)
                        resultView.removeFromSuperview()
                        self.reLayoutParamView()
                    }
                }.disposed(by: resultView.disposeBag)
                
                return resultView
            }
            fatalError("Can not find ParamView from xib")
        } else {
            fatalError("Locad ParamView From xib failure!")
        }
    }
    
    func reLayoutParamView() {
        if let docView = paramScrollView.documentView {
            docView.frame =
                CGRect(x: Double(docView.frame.origin.x),
                       y: Double(docView.frame.origin.y),
                       width: Double(paramScrollView.frame.width),
                       height: Double(paramViewHeight * CGFloat(paramViews.count)))
        }
        
        if paramViews.isEmpty {return}
        
        var paramViewsCopy = paramViews.map { $0 }
        
        var firstParamViewOriginY: CGFloat = 0.0
        let needScroll = CGFloat(paramViewsCopy.count) * paramViewHeight > paramScrollView.frame.height
        if !needScroll {
            firstParamViewOriginY = paramScrollView.frame.height - (CGFloat(paramViewsCopy.count) * paramViewHeight)
        }
        
        let firstParamView = paramViewsCopy.remove(at: 0)
        firstParamView.snp.remakeConstraints { (maker) in
            maker.bottom.equalTo(paramScrollView.snp.bottom).offset(-firstParamViewOriginY)
            maker.left.equalToSuperview()
            maker.height.equalTo(paramViewHeight)
            maker.right.equalToSuperview()
        }
        
        paramViewsCopy.enumerated().forEach { (offset, item) in
            item.snp.remakeConstraints { (maker) in
                maker.bottom.equalTo(firstParamView.snp.top).offset(-paramViewHeight * CGFloat(offset))
                maker.left.equalToSuperview()
                maker.height.equalTo(paramViewHeight)
                maker.right.equalToSuperview()
            }
        }

        paramScrollView.needsLayout = true
        paramScrollView.layoutSubtreeIfNeeded()
    }
    
    func clearParams() {
        paramViews.forEach { (item) in
            item.removeFromSuperview()
        }
        paramViews.removeAll()
    }
    
    func updateClearParamButtonStatus() {
        clearParamButton.isHidden = paramViews.isEmpty
    }
    
    func resetAllData() {
        hatNameTextField.stringValue = ""
        
        requestFungiRadio.state = NSControl.StateValue.on
        requestMogoRadio.state = NSControl.StateValue.off
        
        fetcherPopup.selectItem(at: 0)
        
        postRadio.state = NSControl.StateValue.on
        getRadio.state = NSControl.StateValue.off
        
        pathTextField.stringValue = ""
        outputTextField.stringValue = ""
        progressBar.animates = false
        clearParams()
        
        viewModel.resetEntity(BuilderEntity(projectLocation: viewModel.entity.projectLoc))
    }
}
