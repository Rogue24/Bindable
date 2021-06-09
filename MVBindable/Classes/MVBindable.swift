//
//  MVBindable.swift
//  Neves
//
//  Created by aa on 2021/6/4.
//

import UIKit

infix operator ~~~

protocol MBindable: AnyObject {
    associatedtype Identifier: Any
    associatedtype BindView: VBindable
    var identifier: Identifier { get }
    var bindView: BindView? { set get }
    static func ~~~ (_ model: Self, _ view: BindView?) -> Bool
}

protocol VBindable: UIView {
    associatedtype BindModel: MBindable
    var bindModel: BindModel? { set get }
    static func ~~~ (_ view: Self, _ model: BindModel?) -> Bool
}

extension MBindable {
    @discardableResult
    static func ~~~ (_ model: Self, _ view: BindView?) -> Bool {
        model.bindView?.bindModel = nil
        view?.bindModel?.bindView = nil
        
        guard let bindView = view,
              let bindModel = model as? BindView.BindModel else
        {
            model.bindView = nil
            view?.bindModel = nil
            return false
        }
        
        model.bindView = bindView
        bindView.bindModel = bindModel
        return true
    }
}

extension VBindable {
    @discardableResult
    static func ~~~ (_ view: Self, _ model: BindModel?) -> Bool {
        model?.bindView?.bindModel = nil
        view.bindModel?.bindView = nil
        
        guard let bindModel = model,
              let bindView = view as? BindModel.BindView else
        {
            model?.bindView = nil
            view.bindModel = nil
            return false
        }
        
        bindModel.bindView = bindView
        view.bindModel = bindModel
        return true
    }
}
