import Foundation

/*
 首先
 在未排序的数列中找到最小(or最大)元素，
 然后将其存放到数列的起始位置；
 接着，
 再从剩余未排序的元素中继续寻找最小(or最大)元素，
 然后放到已排序序列的末尾。
 以此类推，直到所有元素均排序完毕。
 */

/*
 时间复杂度和稳定性

 选择排序的时间复杂度是 [公式] ：假设被排序的数列中有N个数。遍历一趟的时间复杂度是O(N)，需要遍历多少次呢？N-1次因此，选择排序的时间复杂度是 O(n^2)。

 选择排序是稳定的算法，它满足稳定算法的定义：假设在数列中存在a[i]=a[j]，若在排序之前，a[i]在a[j]前面；并且排序之后，a[i]仍然在a[j]前面。则这个排序算法是稳定的！
 */

var array: [Int] = [13,6,45,11,43,67,38,34]

func linerSort<E: Comparable>(arr: inout [E]) {
    
    for i in 0..<arr.count {
        
        var temp_index = i
        
        for j in i..<arr.count {
            if arr[temp_index] > arr[j] {
                temp_index = j
            }
        }
        
        if i != temp_index {
            let temp_i_value = arr[i]
            arr[i] = arr[temp_index]
            arr[temp_index] = temp_i_value
        }
    }
}

linerSort(arr: &array)

print(array)
