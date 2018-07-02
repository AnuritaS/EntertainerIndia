//
//  Constant.swift
//  Entertainer
//
//  Created by Anurita Srivastava on 19/01/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import UIKit

class Constant{
   
    //access_token eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI1YTU0MDhiZjcxNjM4ODllNzA3MDAxYWIiLCJhY2Nlc3NfbGV2ZWwiOiJ1c2VyIiwidG9rZW5fdHlwZSI6ImF1dGgiLCJpYXQiOjE1MTY5MDYzMDksImV4cCI6MTUxNjk5MjcwOX0.S5nl4j2pmqT92OyRSKFa61XGMzl_9a6h5U4FMVwPT-w
   let baseURL = "https://test.entertainerindia.com/api/v1/"
   
}
extension DateFormatter {
    
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}

extension String {
    
    func toDate (format: String) -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
    
    func toDateString (inputFormat: String, outputFormat:String) -> String? {
        if let date = toDate(format: inputFormat) {
            return DateFormatter(format: outputFormat).string(from: date)
        }
        return nil
    }
}

extension Date {
    
    func toString (format:String) -> String? {
        return DateFormatter(format: format).string(from: self)
    }
}
func daySuffix(from date: Date) -> String {
    let calendar = Calendar.current
    let dayOfMonth = calendar.component(.day, from: date)
    switch dayOfMonth {
    case 1, 21, 31: return "st"
    case 2, 22: return "nd"
    case 3, 23: return "rd"
    default: return "th"
}
}
