//: [Previous](@previous)

import Foundation
/*
 给定一个数组 prices ，其中 prices[i] 表示股票第 i 天的价格。
 
 在每一天，你可能会决定购买和/或出售股票。你在任何时候 最多 只能持有 一股 股票。你也可以购买它，然后在 同一天 出售。
 返回 你能获得的 最大 利润
 
 示例 1:
 
 输入: prices = [7,1,5,3,6,4]
 输出: 7
 解释: 在第 2 天（股票价格 = 1）的时候买入，在第 3 天（股票价格 = 5）的时候卖出, 这笔交易所能获得利润 = 5-1 = 4 。
      随后，在第 4 天（股票价格 = 3）的时候买入，在第 5 天（股票价格 = 6）的时候卖出, 这笔交易所能获得利润 = 6-3 = 3 。
 示例 2:
 
 输入: prices = [1,2,3,4,5]
 输出: 4
 解释: 在第 1 天（股票价格 = 1）的时候买入，在第 5 天 （股票价格 = 5）的时候卖出, 这笔交易所能获得利润 = 5-1 = 4 。
      注意你不能在第 1 天和第 2 天接连购买股票，之后再将它们卖出。因为这样属于同时参与了多笔交易，你必须在再次购买前出售掉之前的股票。
 示例 3:
 
 输入: prices = [7,6,4,3,1]
 输出: 0
 解释: 在这种情况下, 没有交易完成, 所以最大利润为 0。
  
 
 提示：
 
 1 <= prices.length <= 3 * 104
 0 <= prices[i] <= 104
 
 作者：力扣 (LeetCode)
 链接：https://leetcode-cn.com/leetbook/read/top-interview-questions-easy/x2zsx1/
 来源：力扣（LeetCode）
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */

let prices: [Int] = [1,2,3,4,5]//[7,1,5,3,6,4]



/// 计算最大利润(动态规划) 时间复杂度O(n^2)
/// - Parameter prices: 购入卖出价格表
/// - Returns: 最大利润
func maxProfit(_ prices: [Int]) -> Int {
    
    if prices.count <= 1 {
        return 0
    }
    
    // 状态定义, 构建数组, 初始化 第一天的利润为0
    // dp[k][i] i: 第i天卖出的利润, k: 第几次操作(买入,卖出)
    var dp: [Int] = [0]
    
    // 最小值如果用一个变量保存,就可以定义一维数组,可能会更好理解一点
    var minPrice = prices[0]
    
    // 状态转移方程（数组存值）
    for (k, v) in prices.enumerated() where k > 0 {
        
        // 状态1: 卖出
        let m1 = max(0, v - minPrice)                                   // 当前的利润
        let subM1 = maxProfit(prices.suffix(prices.count - k - 1))      // 子集的利润
        let cm = m1 + subM1                                             // 总利润
        
        // 状态2: 继续(下一步,当前不买入也不卖出)
        minPrice = min(minPrice, v)                                     // 替换当前的最小值
        
        // 状态
        dp.append(max(cm, dp[k-1]))                                     // 保存状态
    }
    print(prices, dp, separator: "->")
    return dp.last ?? 0                                                 // 返回最大利润
}

//print(prices)
//print("--------------------")
//print("max price: \(maxProfit(prices))")


/// 计算最大利润(动态规划)  时间复杂度O(n)
/// - Parameter prices: 购入卖出价格表
/// - Returns: 最大利润
func maxProfitII(_ prices: [Int]) -> Int {
    
    if prices.count == 0 {
        return 0
    }
    
    // 状态定义, 构建数组, 初始化 第一天的利润为0
    // dp[i][k] i: 第i天卖出的利润, k: 有无股票(0, 1)
    var dp = [[Int]]()
    
    // 初始化  第一天收益0 ,如果购入股票责余额 -prices[0]
    dp.append([0,-prices[0]])
    
    // 状态转移方程（数组存值）
    for (k, v) in prices.enumerated() where k > 0 {
        
        let m1 = max(dp[k-1][0], v + dp[k-1][1])        // 上一天购买股票卖出后的利润, 亏了就不卖
        let m2 = max(dp[k-1][1], dp[k-1][0] - v)        // 购入股票后的余额, 亏了就不买
        dp.append([m1,m2])
    }
    print(prices, dp, separator: "->")
    return dp.last?[0] ?? 0                             // 返回最大利润
}

//print(prices)
//print("--------------------")
//print("max price: \(maxProfitII(prices))")

/// 计算最大利润(贪心算法)  时间复杂度O(n)
/// - Parameter prices: 购入卖出价格表
/// - Returns: 最大利润
func maxProfitIII(_ prices: [Int]) -> Int {
    
    if prices.count == 0 {
        return 0
    }
    
    // 状态定义, 构建数组, 初始化 第一天的利润为0
    // dp[i][k] i: 第i天卖出的利润, k: 有无股票(0, 1)
    var dp = [[Int]]()
    
    // 初始化  第一天收益0 ,如果购入股票责余额 -prices[0]
    dp.append([0,-prices[0]])
    
    // 状态转移方程（数组存值）
    for (k, v) in prices.enumerated() where k > 0 {
        
        let m1 = max(dp[k-1][0], v + dp[k-1][1])        // 上一天购买股票卖出后的利润, 亏了就不卖
        let m2 = max(dp[k-1][1], dp[k-1][0] - v)        // 购入股票后的余额, 亏了就不买
        dp.append([m1,m2])
    }
    print(prices, dp, separator: "->")
    return dp.last?[0] ?? 0                             // 返回最大利润
}

//print(prices)
//print("--------------------")
//print("max price: \(maxProfitIII(prices))")


let nums = [1,4,4]//[2,3,1,2,4,3]
func minSubArrayLen(_ target: Int, _ nums: [Int]) -> Int {

    var slow = 0
    var fast = 1
    var len = 0
    var count = nums[0]
    
    while slow < nums.count && fast < nums.count {
        
        print(nums[slow], nums[fast])
        if nums[slow] == target {
            len = 1
            slow += 1
            fast += 1
            count = nums[slow]
        }else if count == target {
            len = fast - slow
            slow += 1
            fast += 1
        }else if count < target{
            count += nums[fast]
            fast += 1
            
        }
//        else if count > target {
//
//        }
        else {
            count -= nums[slow]
            count += nums[fast]
            slow += 1
            fast += 1
            
        }
    }
    
    return len
}
print(nums)
print("--------------------")
print("minSubArrayLen: \(minSubArrayLen(4, nums))")
