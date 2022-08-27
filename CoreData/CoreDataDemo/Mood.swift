//
//  Mood.swift
//  CoreDataDemo
//
//  Created by 9527 on 2022/8/27.
//

import Foundation
import CoreData
import UIKit

//MARK: - 1. 数据建模
//MARK: - 第一步 实体和属性

//MARK: - 第二步： 创建托管对象子类
/*
 建议不要使用 Xcode 的代码生成工具 (Editor > Create NSManagedObject Subclass...) ，而是直接手写它们。到最后，你会发现你每次只需要写很少几行代码，就能带来完全掌控它们的好处。此外，手写代码还会让整个流程变得更加清楚，你会发现其中并没有什么魔法
 */
final class Mood: NSManagedObject {
    
    /*
     修饰 Mood 类属性的 @NSManaged 标签告诉编译器这些属性将由 Core Data 来实现。Core Data 用一种很不同的方式来实现它们，我们会在第二部分里详细谈论这部分内容。fileprivate(set) 这个访问控制修饰符表示这两个属性都是公开只读的。Core Data 其实并不强制执行这样的只读策略，但我们在类中定义了这些标记，于是编译器将保证它们是公开只读的。
     */
    @NSManaged fileprivate(set) var data: Date
    @NSManaged fileprivate(set) var colors: [UIColor]
    
    // 了能让 Core Data 识别我们的 Mood 类，并把它和 Mood 实体相关联，我们在模型编辑器里选中这个实体，然后在 data model inspector 里输入它的类名
    
    
    
}

extension Mood {
    
    static func inser(into context: NSManagedObjectContext, colors: [UIColor]) -> Mood {
        
        // 通过 A 来定义了一个泛型方法，A 是遵从 Managed 协议的 NSManagedObject 子类型。编译器会从方法的类型注解 (type annotation) 自动推断出我们尝试插入的对象类型
        let mood: Mood = context.insertObject()
        mood.data = Date()
        mood.colors = colors
        return mood
    }
}

// 给模型类添加一些方法，让之后的代码变得更容易使用和维护
protocol Managed: NSFetchRequestResult {
    
    static var entityName: String {get}
    static var defaultSortDescriptors: [NSSortDescriptor] {get}
}

// 利用 Swift 的协议扩展来为 defaultSortDescriptors 添加一个默认的实现，同时也作为这个实体的一个使用默认排序描述符的获取请求的计算属性 (computed property)
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

// 通过约束为 NSManagedObject 子类型的协议扩展来给静态的 entityName 属性添加一个默认实现
extension Managed where Self: NSManagedObject {
    static var entityName: String { return entity().name! }
}

//MARK: - 2 设置Core Data 栈
// 可以使用 NSPersistentContainer 来设置一个基本的 Core Data 栈。我们将使用如下的方法来创建这个容器，从中我们可以获取将在整个 app 里都被使用的托管对象上下文
func createMoodyContainer(completetion: @escaping (NSPersistentContainer) -> Void) {
    
    /*
     创建并命名了一个持久化容器 (persistent container)。
     Core Data 使用这个名字来查找对应的数据模型，所以它应该和你的 .xcdatamodeld bundle 的文件名一致。
     接下来，我们调用容器的 loadPersistentStores 方法来尝试打开底层的数据库文件。
     如果数据库文件还不存在， Core Data 会根据你在数据模型里定义的大纲 (schema) 来生成它
     */
    let container = NSPersistentContainer(name: "Area")
    container.loadPersistentStores { (_, error) in
        guard error == nil else {
            fatalError("Falied Create Container: \(error!)")
        }
        
        /*
         因为持久化存储们是 异步加载 的，一旦一个存储被加载完成，我们的回调就会被执行。
         如果发生了一个错误，我们现在就直接让程序崩溃掉。
         在生产环境中，你可能需要采取不同的反应，比如迁移已有的存储到新的版本，或者作为最后的手段，删除并重新创建这个存储
         */
        
        // 回到主线程
        DispatchQueue.main.async {
            completetion(container)
        }
    }
    
    /*
     因为我们已经把这些模板代码都封装到了一个简洁的辅助方法里，我们可以在应用程序代理 (application delegate) 里通过一个简单的 createMoodyContainer() 方法调用来初始化持久化容器
     */
}


//MARK: - 3. 显示数据
//MARK: -

extension Mood: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
}

class MoodyManager: NSObject {
    
    private(set) var persistentContainer: NSPersistentContainer!
    
    private(set) var managerObjectContent: NSManagedObjectContext?
    
    static let shared = MoodyManager()
    override init() {
        super.init()
        
        /* 一旦我们接收持久化容器参数的回调被执行，我们就把这个容器存储在一个属性里 */
        createMoodyContainer(completetion: {
            
            self.persistentContainer = $0
            self.managerObjectContent = $0.viewContext
        })
    }
    
    //MARK: - 第一步 获取数据
    /*
     一个获取 (Fetch) 请求描述了哪些数据需要被从持久化存储里取回，以及它们是如何被取回的。
     获取请求来取回所有的 Mood 实例，并把它们按照创建时间进行排序。
     获取请求还可以设置非常复杂的过滤条件，并只取回一些特定的对象
     */
    func requestData(tableView: UITableView) {
        
        guard let managerObjectContent = managerObjectContent else {
            return
        }

        
        // 创建request
        let request = Mood.sortedFetchRequest
        request.fetchBatchSize = 20
        
        /*
         每次你执行一个获取请求，Core Data 会穿过整个 Core Data 栈，直到文件系统。按照 API 约定，
         获取请求就是往返的：
            从上下文，经过持久化存储协调器和持久化存储，降入 SQLite，然后原路返回。
         
         这个 entityName 参数是我们的 Mood 实体在数据模型里的名称。
         而 fetchBatchSize 属性告诉 Core Data 一次只获取特定的数量的 mood 对象。这背后其实发生了许多“魔法”；我们会在访问数据章节里深入了解这些机制。我们设置的获取批次大小为 20，这大约也是屏幕能显示项数的两倍
         */
        
        request.returnsObjectsAsFaults = false
        
        //MARK: - 第二步 Fetched Results Controller
        // 使用 NSFetchedResultsController 类来协调模型和视图。在我们的例子里，我们用它来让 table view 和 Core Data 中的 mood 对象保持一致。fetched results controller 还可以用于其他场景
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: managerObjectContent,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        /*
         主要优势是：我们不是直接执行获取请求然后把结果交给 table view，而是在当底层数据有变化的时候，它能通知我们，让我们很容易地更新 table view。为了做到这一点，fetched results controllers 监听了一个通知，这个通知会由托管对象上下文在它之中的数据发生改变的时候所发出 (修改和保存数据这一章会更多有关于这方面的内容)。fetched results controllers 会根据底层获取请求的排序，计算出哪些对象的位置发生了变化，哪些对象是新插入的等等，然后把这些改动报告给它的代理
         */
        
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch  {
            print(error)
        }
    }
}

extension MoodyManager: NSFetchedResultsControllerDelegate {
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshot) {
//
//    }

//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith diff: CollectionDifference<NSManagedObjectID>) {
//
//    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print(controller, anObject, indexPath, type, newIndexPath)
    }

//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//
//    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print(controller)
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print(controller)
    }

//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
//        return nil
//    }
}


// MARK: - 插入数据
extension MoodyManager {
    
    func insertData() {
        
        guard let managerObjectContent = managerObjectContent else {
            return
        }
        
        managerObjectContent.performChanges { [weak self] in
            guard let `self` = self else { return }
            _ = Mood.inser(into: managerObjectContent, colors: [UIColor.random, UIColor.random])
        }
        
    }
}

// 优化操作
extension NSManagedObjectContext {
    
    func insertObject<A: NSManagedObject>() -> A where A: Managed {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else {
            fatalError("Wrong object type")
        }
        return obj
    }
    
    /*
     saveOrRollback，直接捕获了调用 save 方法可能抛出的异常，并在出错的时候回滚挂起的改动。也就是说，它直接扔掉了那些没有保存的数据。
     对于我们的示例 app 而言，这是一种可以接受的行为，因为在我们的设置里，单个托管对象上下文是不会出现保存冲突的。
     然而具体到你能否这么做，还是取决于你使用 Core Data 的方式，
     也许你需要更精密的处理。修改和保存数据和使用多上下文的问题这两章中都会有关于如何解决保存冲突的更深入的内容。
     */
    func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch  {
            
            rollback()
            return false
        }
    }
    
    /*
     performChanges，调用了上下文的 perform(_ block:) 方法，它将执行作为参数传入的函数，然后保存上下文。调用 perform 方法能确保我们是从正确的队列里访问上下文和它的托管对象。当我们需要添加第二个在后台队列里的上下文的时候，这就显得很重要了。现在的话，你只需要把这种做法当成一个最佳实践模式即可：始终把和 Core Data 对象交互的代码封装进类似的一个 block 里。
     */
    func performChanges(block: @escaping ()->Void) {
        perform {
            block()
            _ = self.saveOrRollback()
        }
    }
}
