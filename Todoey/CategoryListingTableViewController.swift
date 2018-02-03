//
//  CategoryListingTableViewController.swift
//  CoreDataTesting
//
//  Created by Faraz Haider on 1/28/18.
//  Copyright © 2018 Faraz Haider. All rights reserved.
//

import UIKit
import  RealmSwift
class CategoryListingTableViewController: UITableViewController {

    var categoryArray : Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print(documentsPath)
       loadCategories()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
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

