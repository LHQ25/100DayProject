

import Foundation
import RxSwift
import RxCocoa

class ShoppingCart {
    static let sharedCart = ShoppingCart()
    
    //原来的数组 存储选择后的数据
//    var chocolates: [Chocolate] = []
    //修改
    let chocolates: BehaviorRelay<[Chocolate]> = BehaviorRelay(value: [])
}

//MARK: Non-Mutating Functions
extension ShoppingCart {
    var totalCost: Float {
        return chocolates.value.reduce(0) {
            runningTotal, chocolate in
            return runningTotal + chocolate.priceInDollars
        }
    }
    
    var itemCountString: String {
        guard chocolates.value.count > 0 else {
            return "🚫🍫"
        }
        
        //Unique the chocolates
        let setOfChocolates = Set<Chocolate>(chocolates.value)
        
        //Check how many of each exists
        let itemStrings: [String] = setOfChocolates.map {
            chocolate in
            let count: Int = chocolates.value.reduce(0) {
                runningTotal, reduceChocolate in
                if chocolate == reduceChocolate {
                    return runningTotal + 1
                }
                
                return runningTotal
            }
            
            return "\(chocolate.countryFlagEmoji)🍫: \(count)"
        }
        
        return itemStrings.joined(separator: "\n")
    }
}
