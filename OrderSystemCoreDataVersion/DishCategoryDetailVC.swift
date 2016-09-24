//
//  DishCategoryDetailVC.swift
//  OrderSystemCoreDataVersion
//
//  Created by Xiaoguang Shi on 22/9/16.
//  Copyright © 2016 Xiaoguang Shi. All rights reserved.
//

import UIKit

class DishCategoryDetailVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var aliasTextField: UITextField!
    
    @IBOutlet weak var thumbImage: UIImageView!
    
    var dishCategoryToEdit: DishCategory?
    
    var newSequenceId: Int16?
    
    var imagePicker: UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        }
        
        if dishCategoryToEdit != nil {
            
            loadDishCategoryData()
            
        }
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        setupThumbImage()
        
    }
    
    func setupThumbImage() {
        
        thumbImage.layer.cornerRadius = 50
        thumbImage.layer.masksToBounds = true
        thumbImage.layer.borderWidth = 1
        thumbImage.layer.borderColor = UIColor.black.cgColor
        
    }
    
    func loadDishCategoryData() {
        
        if let dishCategory = dishCategoryToEdit {
            
            self.titleTextField.text = dishCategory.title
            
            self.aliasTextField.text = dishCategory.alias
            
            if let img = dishCategory.image as? UIImage {
                self.thumbImage.image = img
            } else {
                self.thumbImage.image = nil
            }
            
        }
        
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        var dishCategory: DishCategory!
        
        if dishCategoryToEdit != nil {
            
            dishCategory = dishCategoryToEdit
            
        } else {
            
            dishCategory = DishCategory(context: context)
            
            if let sequenceId = newSequenceId {
                dishCategory.sequenceId = sequenceId
            }
            
            
        }
        
        
        if let title = titleTextField.text {
            dishCategory.title = title
        }
        
        if let alias = aliasTextField.text {
            dishCategory.alias = alias
        }
        
        if let img = thumbImage.image {
            dishCategory.image = img
        }
        
        ad.saveContext()
        
        _ = navigationController?.popViewController(animated: true)
        
    }

    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        
        if dishCategoryToEdit != nil {
            
            context.delete(dishCategoryToEdit!)
            
            ad.saveContext()
            
        }
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func imagePressed(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            thumbImage.image = img
            
        }
        
        self.imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
}
