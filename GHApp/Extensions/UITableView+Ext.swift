//
//  UITableView+Ext.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/2/28.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import UIKit

extension UITableView {
    
    func reloadDataOnMainThread() {
        DispatchQueue.main.async { self.reloadData() } /// useful extention - must have /// can be used in other projects
    }
    
    
    func removeExcessCells() {
        tableFooterView = UIView(frame: .zero)
    }
}
