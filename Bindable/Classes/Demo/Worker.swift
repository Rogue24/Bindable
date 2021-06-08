//
//  Worker.swift
//  Bindable
//
//  Created by aa on 2021/6/7.
//

import UIKit

enum Worker {
    
    // MARK:- 工作状态
    enum State: Equatable {
        case idle // 空闲
        case prepare // 准备中
        case working(progress: CGFloat) // 工作中
        case done // 完成
    }
    
}
