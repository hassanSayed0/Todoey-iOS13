//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController {
   
    var itemArrey = [Item]()
    var selectedCategory: Category? {
        didSet{
            loadItem()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArrey.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArrey[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done  ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        itemArrey[indexPath.row].done = !itemArrey[indexPath.row].done
        saveItem()
        
    }
    //MARK: - add button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let safeAddedItem = textField.text , textField.text != ""{
                
                
                let newItem = Item(context: self.context)
                newItem.title = safeAddedItem
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArrey.append(newItem)
                self.saveItem()
            }
        }
        alert.addTextField { AlertTextField in
            textField.placeholder = "create new item"
            textField = AlertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - model manupulation methods
    func saveItem(){
        
        do {
            try context.save()
        }catch{
            print("error saving context,\(error)")
            
        }
        
        tableView.reloadData()
    }
    func loadItem(form request : NSFetchRequest<Item> = Item.fetchRequest(),_ predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let addtionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [addtionalPredicate, categoryPredicate])
            request.predicate = compoundPredicate
        }
        else{
            request.predicate = categoryPredicate
        }
        do{
            itemArrey = try context.fetch(request)
        }catch{
            print("error fetching data from context ,\(error)")
        }
        
        tableView.reloadData()
    }
}
//MARK: - search Bar
extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()

        let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItem(form: request,predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

