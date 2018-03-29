//
//  ElementFactoryViewModel.swift
//  MogoAirport
//
//  Created by luhao on 25/03/2018.
//  Copyright © 2018 luhao. All rights reserved.
//

import Cocoa

public class ElementFactoryViewModel {
    
    public var configerItems: [UIConfigerItem]?
    
    private var chooseFileView: ChooseFileView?
    private var chooseFileViewModel: ChooseFileViewModel?
}

// MARK: - Public method
extension ElementFactoryViewModel {
    
    public func product(configers: [UIConfigerItem]) -> [BGView] {
        configerItems = configers
        
        return configers.map(generateElement)
    }
    
}


// MARK: - Private method
extension ElementFactoryViewModel {
    
    private func generateElement(_ configer: UIConfigerItem) -> BGView {
        switch configer.type {
        case .SelectFile:
            let view: ChooseFileView = ChooseFileView.generateView()
            let viewModel = ChooseFileViewModel(configer)
            view.filePath.map { $0?.path ?? "" }.bind(to: viewModel.rx.value).disposed(by: view.rx.disposeBag)
            chooseFileView = view
            chooseFileViewModel = viewModel
            return chooseFileView!
        case .Input:
            ()
        case .Radio:
            ()
        case .List:
            ()
        case .Param:
            ()
        case .Output:
            ()
        }
        return BGView()
    }
}
