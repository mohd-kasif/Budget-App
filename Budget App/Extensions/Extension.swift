//
//  Extension.swift
//  Budget App
//
//  Created by Mohd Kashif on 24/06/24.
//

import Foundation
extension String{
    var isNumeric:Bool{
        Double(self) != nil
    }
    func isGreaterThan(_ value:Double)->Bool{
        guard self.isNumeric else {
            return false
        }
        return Double(self)! > value
    }
}


extension Double{
    func formatCurrency()->String{
        let formatter=NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? "0.0"
    }
}

extension NSSet{
    func toArray<T>()->[T]{
        let array=self.map{$0 as! T}
        return array
    }
}
