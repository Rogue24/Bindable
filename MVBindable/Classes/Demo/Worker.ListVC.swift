//
//  MVBindableVC.swift
//  Neves
//
//  Created by aa on 2021/3/25.
//

import UIKit

extension Worker {
    class ListVC: UIViewController {
        let testCount = 30
        let tableView = UITableView(frame: PortraitScreenBounds, style: .plain)
        var models = [Model]()

        override func viewDidLoad() {
            super.viewDidLoad()
            view.clipsToBounds = true

            cellCount = 0
            modelCount = 0

            for i in 0 ..< testCount {
                let model = Boss.findModel(for: i) ?? Model("打工人\(i + 1)号", i)
                models.append(model)
            }

            jp.contentInsetAdjustmentNever(tableView)
            tableView.contentInset = .init(top: NavTopMargin, left: 0, bottom: DiffTabBarH, right: 0)
            tableView.registerCell(Cell.self)
            tableView.dataSource = self
            tableView.delegate = self
            tableView.rowHeight = Cell.rowHeight
            view.addSubview(tableView)
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            tableView.reloadData()
        }

//        override func viewDidDisappear(_ animated: Bool) {
//            super.viewDidAppear(animated)
//            
//            guard navigationController == nil else { return }
//            Boss.filterWithoutWorking()
//        }
        
        deinit {
            JPrint("ListVC 卒")
        }
    }
}

extension Worker.ListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(for: indexPath) as Worker.Cell
        let model = models[indexPath.row]
        
        // cell ~~~ model
        // or
        model ~~~ cell
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        Worker.Boss.addWorkQueue(model)
    }
}
