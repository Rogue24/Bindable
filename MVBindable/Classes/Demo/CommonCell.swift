//
//  CommonCell.swift
//  MVBindable
//
//  Created by aa on 2021/6/8.
//

import UIKit

class CommonCell: UITableViewCell, VBindable {
    
    // VBindable
    var bindModel: Worker.Model? = nil
    
    func updateState() {}
    
}
