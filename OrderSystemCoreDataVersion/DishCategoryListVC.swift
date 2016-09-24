//
//  ViewController.swift
//  OrderSystemCoreDataVersion
//
//  Created by Xiaoguang Shi on 20/09/2016.
//  Copyright © 2016 Xiaoguang Shi. All rights reserved.
//

import UIKit
import CoreData

class DishCateogyListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var controller: NSFetchedResultsController<DishCategory>!
    
    var maxSequenceId: Int16 = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
    @IBAction func changeEditStatus(_ sender: UIBarButtonItem) {
        
        tableView.isEditing = !tableView.isEditing
        
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
    
    func configureCell(cell: DishCategoryCell, indexPath: IndexPath) {
        
        let dishCategory = controller.object(at: indexPath)
        
        cell.configureCell(dishCategory: dishCategory)
        
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let dishCategory = controller.object(at: indexPath)
        
        performSegue(withIdentifier: "DishCategoryDetailVC", sender: dishCategory)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DishCategoryCell", for: indexPath) as! DishCategoryCell
        
        configureCell(cell: cell, indexPath: indexPath)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
        
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
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            // delete item at indexPath
//        }
//        
//        let share = UITableViewRowAction(style: .normal, title: "Disable") { (action, indexPath) in
//            // share item at indexPath
//        }
//        
//        share.backgroundColor = UIColor.blue
//        
//        return [delete, share]
//    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        print("tableView momveRowAt to")
        
        let sourceDishCategory = controller.object(at: sourceIndexPath)
        let sourceSequenceId = sourceDishCategory.sequenceId
        
        let destinationDishCategory = controller.object(at: destinationIndexPath)
        let destinationSequenceId = destinationDishCategory.sequenceId
        
        
        sourceDishCategory.sequenceId = destinationSequenceId
        

        if sourceSequenceId > destinationSequenceId {
            
            for row in destinationIndexPath.row ..< sourceIndexPath.row {
                
                let indexPath = IndexPath(row: row, section: destinationIndexPath.section)
                let dishCategory = controller.object(at: indexPath)
                dishCategory.sequenceId += 1
                
            }
            
        } else if sourceSequenceId < destinationSequenceId{
            
            for row in sourceIndexPath.row + 1 ... destinationIndexPath.row {
                
                let indexPath = IndexPath(row: row, section: destinationIndexPath.section)
                let dishCategory = controller.object(at: indexPath)
                dishCategory.sequenceId -= 1
                
            }
            
        }
        
        ad.saveContext()
        
        tableView.reloadData()

    }
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<DishCategory> = DishCategory.fetchRequest()
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
                let cell = tableView.cellForRow(at: indexPath) as! DishCategoryCell
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DishCategoryDetailVC" {
            if let destination = segue.destination as? DishCategoryDetailVC {
                if let dishCategory = sender as? DishCategory {
                    destination.dishCategoryToEdit = dishCategory
                }
            }
        } else if segue.identifier == "DishCategoryDetailVCNew" {
            if let destination = segue.destination as? DishCategoryDetailVC {
                maxSequenceId += 1
                destination.newSequenceId = maxSequenceId
            }
        }
        
    }
    
}

