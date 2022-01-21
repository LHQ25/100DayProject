//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by cbkj on 2021/9/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Area")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

//        let req = NSFetchRequest<Area>(entityName: "Area")
//        persistentContainer.viewContext.fetch(<#T##request: NSFetchRequest<NSFetchRequestResult>##NSFetchRequest<NSFetchRequestResult>#>)
//
        
        guard let areaInfo = loadAreaInfo()?.list else {
            return
        }
        
        persistentContainer.loadPersistentStores { descr, error in
          print(descr)
        }
  
        //MARK: - 添加
//        for item in areaInfo {
//
//            let a = Area(entity: Area.entity(), insertInto: nil)
//            a.enTitle = item.enTitle
//            a.areaId = Int64(item.areaId) ?? 0
//            a.title = item.title
//
//            a.child = initData(data: item.child, area: a)
//
//            print(a)
//            persistentContainer.viewContext.insert(a)
//        }
//
//        do {
//            try persistentContainer.viewContext.save()
//        } catch  {
//            print(error)
//        }
        
        // 查询
        let count = try? persistentContainer.viewContext.count(for: NSFetchRequest<Area>(entityName: "Area"))
        print(count)
        
        do {
            let result = try persistentContainer.viewContext.fetch(NSFetchRequest<Area>(entityName: "Area"))
            for item in result {
                print(item.title)
            }
        } catch  {
            print(error)
        }
        
        
        // 删除
//        do {
//            let result = try persistentContainer.viewContext.fetch(NSFetchRequest<Area>(entityName: "Area"))
//            for item in result {
//                persistentContainer.viewContext.delete(item)
//                try persistentContainer.viewContext.save()
//            }
//        } catch  {
//            print(error)
//        }
        
    }
    
    func initData(data: [AreaModel], area: Area) -> NSSet {
        
        if data.count == 0 {
            return []
        }else {
            
            var t = [Area]()
            for item in data {
                
                let a = Area(entity: Area.entity(), insertInto: area.managedObjectContext)
                a.enTitle = item.enTitle
                a.areaId = Int64(item.areaId) ?? 0
                a.title = item.title
                a.child = initData(data: item.child, area: a)
                t.append(a)
            }
            return NSSet(array: t)
        }
    }
    
    
    private func loadAreaInfo() -> AreaTotalModel? {
        let path = Bundle.main.path(forResource: "area", ofType: "json")
        
        guard let path = path, !path.isEmpty, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(AreaTotalModel.self, from: data)
            return model
        } catch  {
            return nil
        }
    }
    
}

