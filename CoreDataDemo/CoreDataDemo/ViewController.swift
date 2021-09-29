//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by cbkj on 2021/9/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var persistentContainer: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createMoodyContainer { container in
            self.persistentContainer = container
            
            
        }
    }
    
    func createMoodyContainer(completion: @escaping (NSPersistentContainer) -> ())
    {
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores { _, error in
            guard error == nil else { fatalError("Failed to load store: \(error)") }
            DispatchQueue.main.async { completion(container) }
        }
    }
    
}

