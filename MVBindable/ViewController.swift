//
//  ViewController.swift
//  MVBindable
//
//  Created by aa on 2021/6/7.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var _workingModels = [Worker.Model]()
    var workingModels: [Worker.Model] {
        set {
            _workingModels = newValue.sorted { $0.identifier < $1.identifier }
            titleLabel.text = _workingModels.count == 0 ? "现在没人打工" : "现在有\(workingModels.count)个打工人"
            tableView.reloadData()
        }
        get { _workingModels }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemIndigo
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        workingModels = Worker.Boss.workingModels
        
        Worker.Boss.startWorkCallback = { [weak self] in
            guard let self = self else { return }
            self.workingModels = Worker.Boss.workingModels
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Worker.Boss.startWorkCallback = nil
    }
    
    @IBAction func jump(_ sender: Any) {
        guard let navCtr = navigationController else {
            return
        }
        navCtr.pushViewController(Worker.ListVC(), animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        workingModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as! MainCell
        let model = workingModels[indexPath.row]
        
        cell ~~~ model
        
        return cell
    }
}

class MainCell: CommonCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var stopBtn: UIButton!
    
    // VBindable
    override var bindModel: Worker.Model? {
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
        case .prepare:
            progressView.progress = 0
        case let .working(progress):
            progressView.progress = Float(progress)
        default:
            break
        }
    }
    
    @IBAction func stopWork() {
        guard let model = bindModel else { return }
        Worker.Boss.stop(model)
    }
}
