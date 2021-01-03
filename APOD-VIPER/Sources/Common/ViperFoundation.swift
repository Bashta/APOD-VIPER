//
//  ViperFoundation.swift
//  APOD-VIPER
//
//  Created by bashta on 04/01/2021.
//

/**
    Following the blog post at: https://theswiftdev.com/how-to-build-swiftui-apps-using-viper/
 
  - Author: Tibor Bödecs
 */

/*
 VIPER
 
 View-to-Presenter
 Presenter-to-View
 
 Router-to-Presenter
 Presenter-to-Router
 
 Interactor-to-Presenter
 Presenter-to-Interactor
 
 
 Module
 # ---
 builds up pointers and returns a UIViewController
 
 
 View implements View-to-Presenter
 # ---
 strong presenter as Presenter-to-View-interface
 
 
 Presenter implements Presenter-to-Router, Presenter-to-Interactor, Presenter-to-View
 # ---
 strong router as Router-to-Presenter-interface
 strong interactor as Interactor-to-Presenter-interface
 weak view as View-to-Presenter-interface
 
 
 Interactor implements Interactor-to-Presenter
 # ---
 weak presenter as Presenter-to-Interactor-interface
 
 
 Router implemenents Presenter-to-Router
 # ---
 weak presenter as Presenter-to-Router-interface
 
 */

// MARK: - Interfaces

public protocol RouterPresenterInterface: class {

}

public protocol InteractorPresenterInterface: class {

}

public protocol PresenterRouterInterface: class {

}

public protocol PresenterInteractorInterface: class {

}

public protocol PresenterViewInterface: class {

}

public protocol ViewPresenterInterface: class {

}

// MARK: - Viper

public protocol RouterInterface: RouterPresenterInterface {
    associatedtype PresenterRouter

    var presenter: PresenterRouter! { get set }
}

public protocol InteractorInterface: InteractorPresenterInterface {
    associatedtype PresenterInteractor

    var presenter: PresenterInteractor! { get set }
}

public protocol PresenterInterface: PresenterRouterInterface & PresenterInteractorInterface & PresenterViewInterface {
    associatedtype RouterPresenter
    associatedtype InteractorPresenter
    associatedtype ViewPresenter

    var router: RouterPresenter! { get set }
    var interactor: InteractorPresenter! { get set }
    var view: ViewPresenter! { get set }
}

public protocol ViewInterface: ViewPresenterInterface {
    associatedtype PresenterView

    var presenter: PresenterView! { get set }
}

public protocol EntityInterface {

}

// MARK: - Module

public protocol ModuleInterface {

    associatedtype View where View: ViewInterface
    associatedtype Presenter where Presenter: PresenterInterface
    associatedtype Router where Router: RouterInterface
    associatedtype Interactor where Interactor: InteractorInterface

    func assemble(view: View, presenter: Presenter, router: Router, interactor: Interactor)
}

public extension ModuleInterface {

    func assemble(view: View, presenter: Presenter, router: Router, interactor: Interactor) {
        view.presenter = (presenter as! Self.View.PresenterView)

        presenter.view = (view as! Self.Presenter.ViewPresenter)
        presenter.interactor = (interactor as! Self.Presenter.InteractorPresenter)
        presenter.router = (router as! Self.Presenter.RouterPresenter)

        interactor.presenter = (presenter as! Self.Interactor.PresenterInteractor)

        router.presenter = (presenter as! Self.Router.PresenterRouter)
    }
}
