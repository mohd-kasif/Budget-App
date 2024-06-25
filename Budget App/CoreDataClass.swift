//
//  CoreDataClass.swift
//  Budget App
//
//  Created by Mohd Kashif on 25/06/24.
//

import Foundation
import CoreData
@objc(BudgetCategory)
public class BudgetCategory:NSManagedObject{
     var totalTransaction:Double{
        let transaction:[Transaction]=transactions?.toArray() ?? []
        return transaction.reduce(0) { next, transaction in
            next+transaction.amount
        }
    }
    
     var remainingAmount:Double{
        amount-totalTransaction
    }
}
