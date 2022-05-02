//
//  MaxHeap.swift
//  优先队列
//
//  Created by 娄汉清 on 2022/3/15.
//

import Foundation

class MaxHeap<E>: NSObject {
    
    private var data = [E]();
    
    func size() -> Int {
        data.count
    }
    
    // 返回一个布尔值，表示堆中是否为空
    func isEmpty() -> Bool {
        data.isEmpty
    }
    
    // 返回完全二叉树数组表示中,一个索引表示的元素的父亲结点的索引
    func parent(index: UInt) -> UInt? {
        
        let i = (index-1)/2
        if i < 0 {
            return nil
        }
        return i
    }
    
    // 返回完全二叉树数组表示中,一个索引表示的元素的左孩子结点的索引。
    func leftChild(index: UInt) -> UInt {
        
        return index * 2 + 1
    }
    
    // 返回完全二叉树数组表示中,一个索引表示的元素的右孩子结点的索引。
    func rightChild(index: UInt) -> UInt {
        
        return index * 2 + 1
    }
    
    func add(e: E) {
        data.append(e)
        shiftUp(k: data.count - 1)
    }
    
    func shiftUp(k: UInt) {
        
        var index = k
        while index != nil {
            index = parent(index: k)
            if data[index] < data[k] {
                data[k] += data[index]
                data[index] = data[k] - data[index]
                data[k] = data[k] - data[index]
            }
        }
    }
    
    func findMax() -> E? {
        
        return data.first
    }
    
    func extractMax() -> E {
        
    }
    
    func shiftDown(k: UInt) {
        
    }
    
    func replace(e: E) -> E {
        
    }
}
