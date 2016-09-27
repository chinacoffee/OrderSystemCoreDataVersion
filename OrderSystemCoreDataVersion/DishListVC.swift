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
    
    var dishCategory: DishCategory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        let longpress = UILongPressGestureRecognizer(target: self, action: #selector(DishCateogyListVC.longPressGestureRecognized(_:)))
        tableView.addGestureRecognizer(longpress)
        
        attemptFetch()
        
    }
    
    func longPressGestureRecognized(_ gestureRecognizer: UIGestureRecognizer) {
        let longPress = gestureRecognizer as! UILongPressGestureRecognizer
        let state = longPress.state
        
        switch state {
        case UIGestureRecognizerState.began:
            
            if !tableView.isEditing {
                tableView.isEditing = true
                saveSequenceButton.isHidden = false
                saveSequenceButton.isEnabled = true
            }
            
            break
        default:
            break
        }
    }
    @IBOutlet weak var saveSequenceButton: UIButton!

    
    @IBAction func saveCellSequence(_ sender: UIButton) {
        
        tableView.isEditing = false
        saveSequenceButton.isHidden = true
        saveSequenceButton.isEnabled = false
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = controller.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
        
    }
    
    func configureCell(cell: DishCell, indexPath: IndexPath) {
        
        let dish = controller.object(at: indexPath)
        
        cell.configureCell(dish: dish)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishCell", for: indexPath) as! DishCell
        
        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let dishCategory = controller.object(at: indexPath)
            
            context.delete(dishCategory)
            
            ad.saveContext()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        print("tableView momveRowAt to")
        
        let sourceDish = controller.object(at: sourceIndexPath)
        let sourceSequenceId = sourceDish.sequenceId
        
        let destinationDish = controller.object(at: destinationIndexPath)
        let destinationSequenceId = destinationDish.sequenceId
        
        
        sourceDish.sequenceId = destinationSequenceId
        
        
        if sourceSequenceId > destinationSequenceId {
            
            for row in destinationIndexPath.row ..< sourceIndexPath.row {
                
                let indexPath = IndexPath(row: row, section: destinationIndexPath.section)
                let dish = controller.object(at: indexPath)
                dish.sequenceId += 1
                
            }
            
        } else if sourceSequenceId < destinationSequenceId{
            
            for row in sourceIndexPath.row + 1 ... destinationIndexPath.row {
                
                let indexPath = IndexPath(row: row, section: destinationIndexPath.section)
                let dish = controller.object(at: indexPath)
                dish.sequenceId -= 1
                
            }
            
        }
        
        ad.saveContext()
        
        tableView.reloadData()
        
    }

    
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Dish> = Dish.fetchRequest()
        let dishCategoryTitle = dishCategory.title!
        fetchRequest.predicate = NSPredicate(format: "toDishCategory.title == %@", dishCategoryTitle)

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
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            print("controller didChange insert")
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            print("controller didChange delete")
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            print("controller didChange update")
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! DishCell
                configureCell(cell: cell, indexPath: indexPath)
            }
            break
        case .move:
            print("controller didChange move")
            //            if let indexPath = indexPath {
            //                tableView.deleteRows(at: [indexPath], with: .fade)
            //            }
            //            if let indexPath = newIndexPath {
            //                tableView.insertRows(at: [indexPath], with: .fade)
            //            }
            break
        }
        
    }

    
}
