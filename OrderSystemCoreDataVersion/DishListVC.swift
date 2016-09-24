//
//  DishListVC.swift
//  OrderSystemCoreDataVersion
//
//  Created by Xiaoguang Shi on 23/9/16.
//  Copyright © 2016 Xiaoguang Shi. All rights reserved.
//

import UIKit
import CoreData

class DishListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<Dish>!
    
    var maxSequenceId: Int16 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        attemptFetch()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
        
    }
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        let sort = NSSortDescriptor(key: "sequenceId", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do {
            
            try controller.performFetch()
            
            if let sequenceId = controller.fetchedObjects?.last?.sequenceId {
                maxSequenceId = sequenceId
            }
            
        } catch {
            
            let error = error as NSError
            print("\(error)")
            
        }
        
    }

    
}
