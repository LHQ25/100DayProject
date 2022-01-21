import Foundation

// 基本思想：每一步将一个待排序的数据插入到前面已经排好序的有序序列中，直到插完所有元素为止。

// 算法实现：直接插入排序是将无序序列中的数据插入到有序的序列中，在遍历无序序列时，首先拿无序序列中的首元素去与有序序列中的每一个元素比较并插入到合适的位置，一直到无序序列中的所有元素插完为止。对于一个无序序列arr{4，6，8，5，9}来说，我们首先先确定首元素4是有序的，然后在无序序列中向右遍历，6大于4则它插入到4的后面，再继续遍历到8，8大于6则插入到6的后面，这样继续直到得到有序序列{4，5，6，8，9}。

var array: [Int] = [13,6,45,11,43,67,38,34]

func insertSort<E: Comparable>(arr: inout [E]) {
    
    for i in 0..<arr.count {
        
        for j in 0...i {
            
            if (i - j - 1) >= 0 && arr[i - j] < arr[i - j - 1] {
                let temp_i_value = arr[i - j - 1]
                arr[i - j - 1] = arr[i - j]
                arr[i - j] = temp_i_value
            }
        }
    }
}

insertSort(arr: &array)

print(array)
