//
//  ItemsListingTableViewController.swift
//  CoreDataTesting
//
//  Created by Faraz Haider on 1/28/18.
//  Copyright © 2018 Faraz Haider. All rights reserved.
//

import UIKit
import CoreData

class ItemsListingTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            //loadItems()
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
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let items = itemArray[indexPath.row]
        cell.textLabel?.text = items.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func addCategoryButtonClicked(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Items", message: "", preferredStyle: .alert)
        let addCategoryButton = UIAlertAction(title: "Add Items", style: .default) { (addAction) in
            print(textField.text!)
//            let item = Item()
//            item.title = textField.text!
//            item.done = false
//            item.parentCategory = self.selectedCategory
//            self.itemArray.append(item)
            self.saveItems()
        }
        alert.addTextField { (addTextField) in
            addTextField.placeholder = "Items"
            textField = addTextField
        }
        alert.addAction(addCategoryButton)
        present(alert, animated: true, completion: nil)
    }
    
//    func loadItems(with request:NSFetchRequest<Item> =  Item.fetchRequest(), predicate : NSPredicate? = nil){
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate
//        {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
//        }else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray =  try context.fetch(request)
//        }
//        catch
//        {
//            print("error in fetching data ---- \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    func saveItems(){
        do {
            try context.save()
        } catch {
            print("error in saving categories \(error)")
        }
        tableView.reloadData()
    }
    
}

//extension ItemsListingTableViewController : UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if (searchBar.text?.count)! == 0
//        {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//}

