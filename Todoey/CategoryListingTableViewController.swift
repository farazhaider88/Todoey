//
//  CategoryListingTableViewController.swift
//  CoreDataTesting
//
//  Created by Faraz Haider on 1/28/18.
//  Copyright © 2018 Faraz Haider. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryListingTableViewController: SwipeTableViewController {
    
    var categoryArray : Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print(documentsPath)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        loadCategories()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row]{
            
            guard let hexColor = UIColor (hexString: category.backgroundColor) else {fatalError()}
            cell.textLabel?.text = category.name
            cell.backgroundColor = hexColor
            cell.textLabel?.textColor = ContrastColorOf(hexColor, returnFlat: true)
        }
      
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems"{
            let controller = segue.destination as! ItemsListingTableViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                controller.selectedCategory = categoryArray?[indexPath.row]
            }
            
        }
    }
    
    @IBAction func addCategoryButtonClicked(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Category", message: "", preferredStyle: .alert)
        let addCategoryButton = UIAlertAction(title: "Add Category", style: .default) { (addAction) in
            print(textField.text!)
            let category = Category()
            category.name = textField.text!
            category.backgroundColor = UIColor.randomFlat.hexValue()
            self.saveCategories(category: category)
        }
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Category"
            textField = addTextField
        }
        alert.addAction(addCategoryButton)
        present(alert, animated: true, completion: nil)
    }
    
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func saveCategories(category:Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error in saving categories \(error)")
        }
        tableView.reloadData()
    }
    
    //delete action
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryDeletion = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryDeletion)
                }
            }catch
            {
                print("error deleting \(categoryDeletion)")
            }
        }
    }
}


//extension CategoryListingTableViewController : UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        request.predicate = NSPredicate(format: "name CONTAINS [cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//
//        loadCategories(with: request)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if (searchBar.text?.count)! == 0
//        {
//            loadCategories()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//}

