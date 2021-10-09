//
//  Mood.swift
//  CoreDataDemo
//
//  Created by cbkj on 2021/9/23.
//

import AVFoundation
import UIKit
import CoreData

final class Mood: NSManagedObject {

    @NSManaged fileprivate(set) var date: Date
    @NSManaged fileprivate(set) var colors: [UIColor]
    
}

extension Mood: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(date), ascending: false)]
    }
}


// MARK: -
protocol Managed: NSFetchRequestResult {
    
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
}
    
extension Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}

extension Managed where Self: NSManagedObject {
    static var entityName: String { return entity().name!  }
}
    
