//
//  Date+Ext.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/2/11.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "MMM yyyy"
        return dateFormatter.string(from: self) /// make a string from date
    }
}
