//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by cbkj on 2021/9/23.
//

import UIKit
import CoreData
import Combine

class ViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    
    var cancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        cancellable = MoodyManager.shared.$complete
            .sink { [weak self] res in
                guard let `self` = self else { return }
                if res {
                    print("初始化完成")
                    MoodyManager.shared.requestData(tableView: self.tableview)
                }
            }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    private func setupTableView() {
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MoodyManager.shared.insertData()
    }
    
}
