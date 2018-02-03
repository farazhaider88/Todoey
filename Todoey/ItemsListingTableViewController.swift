//
//  ItemsListingTableViewController.swift
//  CoreDataTesting
//
//  Created by Faraz Haider on 1/28/18.
//  Copyright © 2018 Faraz Haider. All rights reserved.
//

import UIKit
import RealmSwift

class ItemsListingTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var todoItems : Results<Item>?
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print(documentsPath)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        if let items = todoItems?[indexPath.row]{
            cell.textLabel?.text = items.title
            cell.accessoryType = items.done ? .checkmark : .none
        }else
        {
            cell.textLabel?.text = "No Items added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch
            {
                print("Error saving done status, \(error)")
            }
        }
    tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addCategoryButtonClicked(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Items", message: "", preferredStyle: .alert)
        let addCategoryButton = UIAlertAction(title: "Add Items", style: .default) { (addAction) in
            print(textField.text!)
            
            if let currentCategory = self.selectedCategory
            {
                do{
                    try self.realm.write {
                        let newItem = Item ()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch
                {
                    print("Error saving in Items \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Items"
            textField = addTextField
        }
        alert.addAction(addCategoryButton)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
}

extension ItemsListingTableViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count)! == 0
        {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}

