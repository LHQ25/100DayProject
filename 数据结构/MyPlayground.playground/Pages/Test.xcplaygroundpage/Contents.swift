//: [Previous](@previous)

import Foundation

//func test(_ array: [Int], _ target: Int) -> [Int]? {
//
//    for i in 0..<array.count {
//
//        if array[i] > target {
//            continue
//        }
//
//        for j in (i+1)..<array.count {
//            if (target - array[i]) == array[j] {
//                return [i, j]
//            }
//        }
//    }
//
//    return nil
//}
//
//
//
//let res = test([3,6,1,9], 11)
//print(res)


var nums: [Int] = [1,1]//[0,0,1,1,1,2,2,3,3,4]
//[1, 1]

func removeDuplicates(_ nums: inout [Int]) -> Int {
    
    if nums.count == 0 {
        return 0
    }
    
//    var i: Int = nums.count - 1
//
//    while (i - 1) >= 0 {
//
//        var j = i - 1
//        while j >= 0 {
//
//            if nums[i] == nums[j] {
//                nums.remove(at: i)
//                i = j
//            }
//            j -= 1
//        }
//        i -= 1
//    }
    
    var slow: Int = 0, fast: Int = slow;
    while slow < nums.count {
        fast += 1
        if fast < nums.count {
            while nums[slow] == nums[fast] {
                nums.remove(at: fast)
                print("2 \(fast), \(nums)")
                if fast >= nums.count {
                    break
                }
            }
            print("1 \(fast), \(nums)")
        }
        slow += 1
        fast = slow
    }
    
    print(nums)
    return nums.count
}

print(removeDuplicates(&nums))


//: [Next](@next)
