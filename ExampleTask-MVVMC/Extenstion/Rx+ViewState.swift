//
//  Rx+ViewState.swift
//  LightningTask
//
//  Created by cschoi on 2023/07/12.
//

import RxCocoa
import RxSwift
import UIKit

public enum ViewControllerViewState: Equatable {
    case viewWillAppear
    case viewDidAppear
    case viewWillDisappear
    case viewDidDisappear
    case viewDidLoad
    case viewDidLayoutSubviews
}

extension RxSwift.Reactive where Base: UIViewController {
    public var viewDidLoad: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLoad))
            .map { _ in return }
    }
    
    public var viewDidLayoutSubviews: Observable<Void> {
        return methodInvoked(#selector(UIViewController.viewDidLayoutSubviews))
            .map { _ in return }
    }
    
    public var viewWillAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { $0.first as? Bool ?? false }
    }
    
    public var viewDidAppear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidAppear))
            .map { $0.first as? Bool ?? false }
    }
    
    public var viewWillDisappear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewWillDisappear))
            .map { $0.first as? Bool ?? false }
    }
    
    public var viewDidDisappear: Observable<Bool> {
        return methodInvoked(#selector(UIViewController.viewDidDisappear))
            .map { $0.first as? Bool ?? false }
    }

    public var viewState: Observable<ViewControllerViewState> {
        return Observable.of(
            viewDidLoad.map { _ in return ViewControllerViewState.viewDidLoad },
            viewDidLayoutSubviews.map { _ in return ViewControllerViewState.viewDidLayoutSubviews },
            viewWillAppear.map { _ in return ViewControllerViewState.viewWillAppear },
            viewDidAppear.map { _ in return ViewControllerViewState.viewDidAppear },
            viewWillDisappear.map { _ in return ViewControllerViewState.viewWillDisappear },
            viewDidDisappear.map { _ in return ViewControllerViewState.viewDidDisappear }
            )
            .merge()
    }
}

// MARK: - UIView
extension RxSwift.Reactive where Base: UIView {
    public var layoutSubviews: Observable<[Any]> {
        return sentMessage(#selector(UIView.layoutSubviews))
    }
}
