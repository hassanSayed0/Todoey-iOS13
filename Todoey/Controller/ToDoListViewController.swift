//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    let defults = UserDefaults.standard
    var itemArrey = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defults.array(forKey: "ToDoListItemsModel") as? [Item] {
            itemArrey = items
            
        }
        let newItem1 = Item()
        newItem1.title = "Say Hello"

        itemArrey.append(newItem1)

    }
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArrey.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArrey[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = (item.done == true) ? .checkmark : .none
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        itemArrey[indexPath.row].done = !itemArrey[indexPath.row].done
        tableView.reloadData()
        //defults.set(itemArrey, forKey: "ToDoListItemsModel")

        
    }
    //MARK: - add button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            if let safeAddedItem = textField.text , textField.text != ""{
                let newItem = Item()
                newItem.title = safeAddedItem
                self.itemArrey.append(newItem)
                self.defults.set(self.itemArrey, forKey: "ToDoListItemsModel")
                self.tableView.reloadData()
            }
        }
        alert.addTextField { AlertTextField in
            textField.placeholder = "create new item"
           textField = AlertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}

