import UIKit

struct AsyncFibonacciSequence: AsyncSequence {
    
    typealias Element = Int
    
    struct AsyncIterator: AsyncIteratorProtocol {
        
        var currentIndex = 0
        
        mutating func next() async throws -> Int? {
            defer { currentIndex += 1 }
            return try await loadFibNumber(at: currentIndex)
        }
        
        // 对于涉及到的 loadFibNumber，为了简化，我们用一个 Task.sleep 来模拟这个耗时操作。
        func loadFibNumber(at index: Int) async throws -> Int? {
            // 使用 Task.sleep 模拟 API 调用...
            await Task.sleep(NSEC_PER_SEC)
            return fibNumber(at: index)
        }
        
        private func fibNumber(at index: Int) -> Int {
            if index == 0 { return 0 }
            if index == 1 { return 1 }
            return fibNumber(at: index - 2) + fibNumber(at: index - 1)
        }
    }
    
    func makeAsyncIterator() -> AsyncIterator {
        .init()
    }
}

var aa = AsyncFibonacciSequence().makeAsyncIterator()
print(try await aa.next())
