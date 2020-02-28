//
//  String+Ext.swift
//  GHApp
//
//  Created by Лена Мырленко on 2020/2/11.
//  Copyright © 2020 Alexey Kirpichnikov. All rights reserved.
//

import Foundation

extension String {
    
    func convertStringToDate() -> Date? {
        
        let dateFormatter           = DateFormatter()
        dateFormatter.dateFormat    = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale        = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone      = .current
        
        return dateFormatter.date(from: self) /// make a date from string
    }
    
    
    func convertToDisplayFormat() -> String {
        guard let date = self.convertStringToDate() else { return "N/A" }
        return date.convertToMonthYearFormat()
    }
}
