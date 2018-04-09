//
//  ElementFactoryViewModel.swift
//  MogoAirport
//
//  Created by luhao on 25/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

public final class ElementFactoryViewModel {
    
    private var dataCenter: YamlDataService?
    private var elements: [(BGView, ElementViewModelProtocol)] = []
}


// MARK: - Public method
extension ElementFactoryViewModel {
    
    public func setDataCenter(_ dc: YamlDataService) {
        dataCenter = dc
        
    }
    
    public func updateElement() {
        guard let dc = dataCenter else {
            return
        }
        elements = dc.uiConfiger.map(generateElement)
    }

    public var views: [BGView] {
        return elements.map { $0.0 }
    }
    
    public var viewModels: [ElementViewModelProtocol] {
        return elements.map { $0.1 }
    }
    
    public var keyValue: [String: Any] {
        var dic: [String: Any] = [:]
        views.enumerated().forEach { (itemView) in
            let key = self.viewModels[itemView.offset].uiItem.key
            if let eleView = itemView.element as? ElementViewProtocol,
                let value = eleView.value {
                dic[key] = value
            }
        }
        return dic
    }
    
    public func resetViews() {
        views.forEach {
            guard let eleView = $0 as? ElementViewProtocol else {
                return
            }
            eleView.emptyValue()
        }
    }
}


// MARK: - Private method
extension ElementFactoryViewModel {
    
    private func generateElement(_ configer: UIConfigerItem) -> (BGView, ElementViewModelProtocol) {
        switch configer.type {
        case .SelectFile:
            
            let view: ChooseFileView = ChooseFileView.generateView()
            let viewModel = ChooseFileViewModel(configer)
            view.filePath.map { $0?.path ?? "" }.bind(to: viewModel.rx.value).disposed(by: view.rxDisposeBag)
            view.nameLabel.stringValue = "选择工程目录"
            return (view, viewModel)
            
        case .Input:
            
            let view: InputView = InputView.generateView()
            let viewModel = InputViewModel(configer)
            view.inputValue.bind(to: viewModel.rx.stringValue).disposed(by: view.rxDisposeBag)
            BehaviorSubject(value: viewModel.uiItem.name).bind(to: view.rx.name).disposed(by: view.rxDisposeBag)
            return (view, viewModel)
            
        case .Radio:
            
            let view: RadioSelectedView = RadioSelectedView.generateView()
            let viewModel: RadioSelectedViewModel = RadioSelectedViewModel(configer)
            view.selectItem.bind(to: viewModel.rx.stringValue).disposed(by: view.rxDisposeBag)
            BehaviorSubject(value: viewModel.uiItem.name).bind(to: view.rx.name).disposed(by: view.rxDisposeBag)
            viewModel.optionItems.bind(to: view.rx.items).disposed(by: view.rxDisposeBag)
            return (view, viewModel)
            
        case .List:
            
            let view: ListSelectedView = ListSelectedView.generateView()
            let viewModel = ListSelectedViewModel(configer)
            view.name = viewModel.name
            viewModel.options.bind(to: view.rx.options).disposed(by: view.rxDisposeBag)
            return (view, viewModel)
            
        case .Param:
            
            let view: ParametersView = ParametersView.generateView()
            let viewModel = ParametersViewModel(configer)
            BehaviorSubject(value: viewModel.uiItem.name).bind(to: view.rx.name).disposed(by: view.rxDisposeBag)
            return (view, viewModel)
            
        }
    }
}
