//
//  Worker.Bindable.swift
//  Bindable
//
//  Created by aa on 2021/6/7.
//

import UIKit

var cellCount = 0
var modelCount = 0

class WorkerCell: UITableViewCell, VBindable {
    var bindModel: Worker.Model? = nil
    func updateState() {}
}

extension Worker {
    class Model: NSObject, MBindable {
        let name: String
        
        // MBindable
        let identifier: Int
        weak var bindView: WorkerCell? = nil
        
        var state: State = .idle {
            didSet {
                bindView?.updateState()
            }
        }

        init(_ name: String, _ identifier: Int) {
            self.name = name
            self.identifier = identifier

            modelCount += 1
        }

        deinit {
            modelCount -= 1
            JPrint("Model 卒，剩", modelCount)
        }
    }
}

extension Worker {
    class Cell: WorkerCell, CellReusable {
        static let rowHeight: CGFloat = 80.px
        
        // CellReusable
        static var reuseIdentifier: String { "Worker.Cell" }
        static var nib: UINib? { nil }
        
        let nameLabel = UILabel()
        let stateLabel = UILabel()
        let stopBtn = UIButton(type: .custom)

        // VBindable
        override var bindModel: Model? {
            set {
                super.bindModel = newValue
                guard let model = newValue else {
                    return
                }
                nameLabel.text = model.name
                updateState()
            }
            get { super.bindModel }
        }
        
        override func updateState() {
            guard let model = bindModel else {
                return
            }
            let state = model.state
            switch state {
            case .idle:
                stateLabel.text = ""
            case .prepare:
                stateLabel.text = "准备工作..."
            case let .working(progress):
                stateLabel.text = "正在工作...\(String(format: "%.0f", progress * 100))%"
            case .done:
                stateLabel.text = "完成工作"
            }
            stopBtn.isHidden = state == .idle || state == .done
        }
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            contentView.backgroundColor = .quaternarySystemFill

            nameLabel.textColor = .systemBlue
            nameLabel.font = .systemFont(ofSize: 20.px)
            nameLabel.frame = [20.px, 0, PortraitScreenWidth - 40.px, Self.rowHeight]
            contentView.addSubview(nameLabel)

            stateLabel.textColor = .systemOrange
            stateLabel.font = .systemFont(ofSize: 15.px)
            stateLabel.textAlignment = .right
            stateLabel.frame = [PortraitScreenWidth - nameLabel.width - 20.px, 42.px, nameLabel.width, stateLabel.font.lineHeight]
            contentView.addSubview(stateLabel)
            
            stopBtn.setTitle("⏹点我停止工作", for: .normal)
            stopBtn.titleLabel?.font = .systemFont(ofSize: 12.px)
            stopBtn.setTitleColor(.systemRed, for: .normal)
            stopBtn.sizeToFit()
            stopBtn.addTarget(self, action: #selector(strike), for: .touchUpInside)
            stopBtn.isHidden = true
            stopBtn.backgroundColor = .init(white: 0, alpha: 0.1)
            stopBtn.layer.cornerRadius = 5.px
            stopBtn.frame = [PortraitScreenWidth - stopBtn.width - 20.px, 18.px, stopBtn.width + 4.px, stopBtn.height - 4.px]
            contentView.addSubview(stopBtn)
            
            cellCount += 1
        }
        
        @objc func strike() {
            guard let model = bindModel else { return }
            Manager.stop(model)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        deinit {
            cellCount -= 1
            JPrint("Cell 卒，剩", cellCount)
        }
    }
}


