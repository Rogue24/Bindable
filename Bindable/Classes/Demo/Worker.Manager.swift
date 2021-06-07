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
    
    // MARK:- 工作模拟队列
    final class Manager {

        // MARK: 存储属性
        static let maxWorkingCount = 3
        private(set) static var workQueue: [Model] = []
        private static var loopTimer: Timer? = nil

        // MARK: 计算属性
        static var workingCount: Int {
            return workQueue.reduce(0) {
                switch $1.state {
                case .working: return $0 + 1
                default: return $0
                }
            }
        }
        static var workingModels: [Model] {
            return workQueue.filter {
                switch $0.state {
                case .working: return true
                default: return false
                }
            }
        }

        // MARK: 模型是否在工作队列中
        static func isInQueue(_ model: Model) -> Bool {
            for kModel in workQueue where kModel == model {
                return true
            }
            return false
        }

        // MARK: 按标识查找模型
        static func findModel(for identifier: Int) -> Model? {
            for model in workQueue where model.identifier == identifier {
                return model
            }
            return nil
        }
        
        // MARK: 加入工作
        static func addWorkQueue(_ model: Model) {
            guard model.state == .idle, !isInQueue(model) else {
                return
            }
            model.state = .prepare
            workQueue.append(model)
            startWork()
        }

        // MARK: 停止工作
        static func stop(_ model: Model) {
            model.state = .idle
            removeModel(model)
            startWork()
        }

        // MARK: 停止所有工作
        static func stopAll() {
            removeTimer()
            let queue = workQueue
            workQueue.removeAll()
            for model in queue {
                model.state = .idle
            }
        }

        // MARK: 过滤没有工作中的模型
        static func filterWithoutWorking() {
            removeTimer()
            workQueue = workQueue.filter {
                switch $0.state {
                case .working: return true
                default: return false
                }
            }
            beginTimer()
        }
    }
}

private extension Worker.Manager {

    // MARK: 开始工作（最多同时3个一起工作）
    static func startWork() {
        var workingCount = self.workingCount

        for model in workQueue {
            guard workingCount < maxWorkingCount else {
                break
            }

            switch model.state {
            case .prepare:
                model.state = .working(progress: 0)
                workingCount += 1
            default: break
            }
        }

        if workingCount > 0 {
            beginTimer()
        } else {
            removeTimer()
        }
    }

    // MARK: 开始计时
    static func beginTimer() {
        guard loopTimer == nil,
              workQueue.count > 0 else { return }
        let timer = Timer(timeInterval: 1.0, repeats: true) { _ in
            workworkwork()
        }
        RunLoop.main.add(timer, forMode: .common)
        loopTimer = timer
    }

    // MARK: 停止计时
    static func removeTimer() {
        guard let timer = loopTimer else { return }
        timer.invalidate()
        loopTimer = nil
    }

    // MARK: 工作工作工作
    static func workworkwork() {
        guard workQueue.count > 0 else {
            removeTimer()
            return
        }

        for model in workQueue {
            switch model.state {
            case var .working(progress):
                progress += 0.01
                if progress >= 1 {
                    finish(model)
                    break
                }
                model.state = .working(progress: progress)
            default:
                break
            }
        }
    }

    // MARK: 完成工作
    static func finish(_ model: Worker.Model) {
        model.state = .done
        removeModel(model)
        startWork()
    }

    // MARK: 移除模型
    static func removeModel(_ model: Worker.Model) {
        guard let index = workQueue.firstIndex(of: model) else {
            return
        }
        workQueue.remove(at: index)
        if workQueue.count == 0 {
            removeTimer()
        }
    }
}
