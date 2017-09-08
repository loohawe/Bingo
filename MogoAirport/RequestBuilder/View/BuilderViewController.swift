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

fileprivate let paramViewHeight: CGFloat = 36.0

class BuilderViewController: NSViewController
{
    // MARK: Property Public
    
    @IBOutlet weak var locationButton: NSButton!
    @IBOutlet weak var hatNameTextField: NSTextField!
    
    @IBOutlet weak var postRadio: NSButton!
    @IBOutlet weak var getRadio: NSButton!
    
    @IBOutlet weak var pathTextField: NSTextField!
    @IBOutlet weak var paramScrollView: NSScrollView!
    @IBOutlet weak var clearParamButton: NSButton! {
        didSet {
            clearParamButton.isHidden = true
        }
    }
    
    @IBOutlet weak var outputTextField: NSTextField!
    
    // MARK: Property Private
    
    fileprivate var viewModel = BuilderViewModel()
    fileprivate var disposeBag = DisposeBag()
    fileprivate var paramViews = [ParamView]() {
        didSet {
            updateClearParamButtonStatus()
        }
    }
    
    // MARK: Override
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        bindModel()
    }
    
    override func viewWillLayout()
    {
        super.viewWillLayout()
        
        reLayoutParamView()
    }
    
}

// MARK: Actions

extension BuilderViewController
{
    @IBAction func openPanelAction(_ sender: NSButton)
    {
        viewModel.chooseProject {
            [weak self] (success, path) in
            guard let `self` = self else { return }
            
            if success {
                print(path)
            } else {
                self.viewModel.showStupidAlert(in: self.view)
            }
        }
    }
    
    @IBAction func addParametersAction(_ sender: NSButton)
    {
        let paramView = generatParamView()
        paramScrollView.contentView.addSubview(paramView)
        paramViews.append(paramView)
        reLayoutParamView()
    }
    
    @IBAction func radioButtonAction(_ sender: NSButton)
    {
        if sender == postRadio {
            getRadio.state = NSOffState
            postRadio.state = NSOnState
            viewModel.entity.method = .post
        }
        
        if sender == getRadio {
            getRadio.state = NSOnState
            postRadio.state = NSOffState
            viewModel.entity.method = .get
        }
    }
    
    @IBAction func generatorButtonAction(_ sender: NSButton)
    {
        viewModel.generatorFiles()
        viewModel.excuteUpdateCommand(show: outputTextField)
    }
    
    @IBAction func clearParamButtonAction(_ sender: NSButton)
    {
        paramViews.forEach { (item) in
            item.removeFromSuperview()
        }
        paramViews.removeAll()
    }
}

// MARK: Method Private

extension BuilderViewController
{
    func bindModel()
    {
        viewModel.locSubject.subscribe { (event) in
            self.locationButton.title = event.element?.path ?? "Choose Project"
        }.addDisposableTo(disposeBag)
        
        hatNameTextField.delegate = viewModel
        pathTextField.delegate = viewModel
        
        viewModel.paramEntityList = {
            self.paramViews.map{ $0.paramEntity }
        }
    }
    
    func generatParamView() -> ParamView
    {
        var array: NSArray = []
        
        if Bundle.main.loadNibNamed("ParamView", owner: self, topLevelObjects: &array) {
            var pView: ParamView?
            array.forEach({ (item) in
                if let paramView = item as? ParamView {
                     pView = paramView
                }
            })
            
            if let resultView = pView {
                
                resultView.closeSubject.subscribe {
                    [weak self, weak resultView](_) in
                    
                    guard let `self` = self else {return}
                    guard let `resultView` = resultView else {return}
                    
                    if let index = self.paramViews.index(of: resultView) {
                        resultView.removeFromSuperview()
                        self.paramViews.remove(at: index)
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
    
    func reLayoutParamView()
    {
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
        let needScroll = CGFloat(paramViews.count) * paramViewHeight > paramScrollView.frame.height
        if !needScroll {
            firstParamViewOriginY = paramScrollView.frame.height - (CGFloat(paramViews.count) * paramViewHeight)
        }
        
        let firstParamView = paramViewsCopy.remove(at: 0)
        firstParamView.frame = CGRect(x: 0.0,
                                      y: Double(firstParamViewOriginY),
                                      width: Double(paramScrollView.frame.width),
                                      height: Double(paramViewHeight))
        
        paramViewsCopy.enumerated().forEach { (offset, item) in
            item.snp.makeConstraints { (maker) in
                maker.bottom.equalTo(firstParamView.snp.top).offset(-paramViewHeight * CGFloat(offset))
                maker.left.equalToSuperview()
                maker.height.equalTo(paramViewHeight)
                maker.right.equalToSuperview()
            }
        }
    }
    
    func updateClearParamButtonStatus()
    {
        clearParamButton.isHidden = paramViews.isEmpty
    }
}
