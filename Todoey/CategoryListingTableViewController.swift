//
//  CategoryListingTableViewController.swift
//  CoreDataTesting
//
//  Created by Faraz Haider on 1/28/18.
//  Copyright © 2018 Faraz Haider. All rights reserved.
//

import UIKit
import CoreData

class CategoryListingTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray = [Category]()
    
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
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems"{
            let controller = segue.destination as! ItemsListingTableViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                controller.selectedCategory = categoryArray[indexPath.row]
            }
            
        }
    }
    
    @IBAction func addCategoryButtonClicked(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Category", message: "", preferredStyle: .alert)
        let addCategoryButton = UIAlertAction(title: "Add Category", style: .default) { (addAction) in
            print(textField.text!)
            let category = Category(context: self.context)
            category.name = textField.text
            self.categoryArray.append(category)
            self.saveCategories()
        }
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Category"
            textField = addTextField
        }
        alert.addAction(addCategoryButton)
        present(alert, animated: true, completion: nil)
    }
    
    func loadCategories(with request:NSFetchRequest<Category> =  Category.fetchRequest()){
        do {
            categoryArray =  try context.fetch(request)
        }
        catch
        {
            print("error in fetching data ---- \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveCategories(){
        do {
            try context.save()
        } catch {
            print("error in saving categories \(error)")
        }
        tableView.reloadData()
    }
    
}

extension CategoryListingTableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        request.predicate = NSPredicate(format: "name CONTAINS [cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadCategories(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count)! == 0
        {
            loadCategories()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
