//
//  NotificationCenter.Extension.swift
//  MVBindable
//
//  Created by aa on 2021/6/9.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

extension NotificationCenter: JPCompatible {}
extension JP where Base: NotificationCenter {
    static func addObserver(_ observer: Any, selector aSelector: Selector, name aName: NSNotification.Name, object anObject: Any? = nil) {
        Base.default.addObserver(observer, selector: aSelector, name: aName, object: anObject)
    }
    
    static func addObserver(_ observer: Any, selector aSelector: Selector, name aName: String, object anObject: Any? = nil) {
        Base.default.addObserver(observer, selector: aSelector, name: Notification.Name(rawValue: aName), object: anObject)
    }
    
    static func addObserver(forName name: NSNotification.Name, object obj: Any? = nil, queue: OperationQueue? = nil, using block: @escaping (Notification) -> Void) {
        Base.default.addObserver(forName: name, object: obj, queue: queue, using: block)
    }
    
    static func addObserver(forName name: String, object obj: Any? = nil, queue: OperationQueue? = nil, using block: @escaping (Notification) -> Void) {
        Base.default.addObserver(forName: Notification.Name(rawValue: name), object: obj, queue: queue, using: block)
    }
    
    static func post(name aName: NSNotification.Name, object anObject: Any? = nil, userInfo aUserInfo: [AnyHashable : Any]? = nil) {
        Base.default.post(name: aName, object: anObject, userInfo: aUserInfo)
    }
    
    static func post(name aName: String, object anObject: Any? = nil, userInfo aUserInfo: [AnyHashable : Any]? = nil) {
        Base.default.post(name: Notification.Name(rawValue: aName), object: anObject, userInfo: aUserInfo)
    }
}
