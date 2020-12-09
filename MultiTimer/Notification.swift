//
//  Notification.swift
//  MultiTimer
//
//  Created by GLEB TISHCHENKO on 9.12.2020.
//  Copyright © 2020 GLEB TISHCHENKO. All rights reserved.
//

import Foundation

extension Notification.Name {
    // properties to represent each custom action
    static let doneButton = Notification.Name("doneTapped")
    static let againButton = Notification.Name("againTapped")
    
    // post meth for Notification.Name
    func post(center: NotificationCenter = NotificationCenter.default, object: Any? = nil, userInfo: [AnyHashable : Any]? = nil) {
        center.post(name: self, object: object, userInfo: userInfo)
    }
    
    // action when post occurs
    @discardableResult
    func onPost(center: NotificationCenter = NotificationCenter.default, object: Any? = nil, queue: OperationQueue? = nil, using: @escaping (Notification) -> Void) -> NSObjectProtocol {
        
        return center.addObserver(forName: self, object: object, queue: queue, using: using)
    }
}
