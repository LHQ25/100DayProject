//
//  ViewController.swift
//  Swift_Async
//
//  Created by 9527 on 2022/5/20.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        
        
        let task = Task {
            await start()
        }
        
    }
    
    func testt() async -> Int {
        
        let r = await withUnsafeContinuation { continuation in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                
                continuation.resume(returning: 9)
            }
        }
        
        print("xiu")
        return r
    }
    
    func testt2() async throws -> Int {

        let r = try await withUnsafeThrowingContinuation { continuation in

            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {

                continuation.resume(returning: 33)
            }
        }

        print("xiu")
        return r
    }
    
    
}


