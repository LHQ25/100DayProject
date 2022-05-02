//: [Previous](@previous)

import Foundation

/*
 买卖股票的最佳时机
 给定一个数组 prices ，它的第 i 个元素 prices[i] 表示一支给定股票第 i 天的价格。

 你只能选择 某一天 买入这只股票，并选择在 未来的某一个不同的日子 卖出该股票。设计一个算法来计算你所能获取的最大利润。

 返回你可以从这笔交易中获取的最大利润。如果你不能获取任何利润，返回 0 。

  

 示例 1：

 输入：[7,1,5,3,6,4]
 输出：5
 解释：在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。
      注意利润不能是 7-1 = 6, 因为卖出价格需要大于买入价格；同时，你不能在买入前卖出股票。
 示例 2：

 输入：prices = [7,6,4,3,1]
 输出：0
 解释：在这种情况下, 没有交易完成, 所以最大利润为 0。
  

 提示：

 1 <= prices.length <= 105
 0 <= prices[i] <= 104

 作者：力扣 (LeetCode)
 链接：https://leetcode-cn.com/leetbook/read/top-interview-questions-easy/xn8fsh/
 来源：力扣（LeetCode）
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 */

/*
 我们来假设自己来购买股票。随着时间的推移，每天我们都可以选择出售股票与否。那么，假设在第 i 天，如果我们要在今天卖股票，那么我们能赚多少钱呢？
 dp[i]

 显然，如果我们真的在买卖股票，我们肯定会想：如果我是在历史最低点买的股票就好了！太好了，
 在题目中，我们只要用一个变量记录一个历史最低价格 minprice，我们就可以假设自己的股票是在那天买的。
 那么我们在第 i 天卖出股票能得到的利润就是
 dp[i] = prices[i] - minprice。

 因此，我们只需要遍历价格数组一遍，记录历史最低点，然后在每一天考虑这么一个问题：
 如果我是在历史最低点买进的，那么我今天卖出能赚多少钱？当考虑完所有天数之时，我们就得到了最好的答案。

 作者：LeetCode-Solution
 链接：https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock/solution/121-mai-mai-gu-piao-de-zui-jia-shi-ji-by-leetcode-/
 来源：力扣（LeetCode）
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

 */

let prices: [Int] = [7,1,5,3,6,4]//[1, 2]

// 贪心算法
func maxProfit(_ prices: [Int]) -> Int {
    
    if prices.count <= 1 {
        return 0
    }
    
    var dp: [Int] = [0]
    
    // 记录之前最小值
    var minValue: Int = Int(1e9)
    // 当前最大收益
    var maxPrcie: Int = 0
    
    for v in prices {
        
        print(v, minValue)
        if maxPrcie < (v - minValue) {
            // 计算最大收益
            maxPrcie = v - minValue
        }
        
        // 重新计算最小值
        minValue = min(minValue, v)
        
        dp.append(maxPrcie)
    }
    // 测试使用 数组,方便记录每天的最大收益
    print(dp)
    return maxPrcie
}


//print("maxProfit: \(maxProfit(prices))")

// 动态规划
func maxProfitII(_ prices: [Int]) -> Int {
    
    if prices.count <= 1 {
        return 0
    }
    
    // 状态定义, 构建数组, 初始化 第一天的利润为0
    // dp[i][j]  i: 第i天卖出的利润, j: 没有操作,比对之前的最低值后替换
    var dp: [[Int]] = [[0, prices[0]]]
    
    // 提示:
    // 最小值如果用一个变量保存,就可以定义一维数组,可能会更好理解一点
    // var minPrice = prices[0]
    
    // 状态转移方程（数组存值）
    for (k, v) in prices.enumerated() where k > 0 {
        
        // 卖出时的利润
        let m1 = max(dp[k-1][0], v - dp[k-1][1])
        // 前面没买, 修改前面的最低价
        let m2 =  min(v, dp[k-1][1])
        
        dp.append([m1, m2])
    }
    print(dp)
    return dp.last?.first ?? 0
}

print(prices)
print("maxProfitII: \(maxProfitII(prices))")
