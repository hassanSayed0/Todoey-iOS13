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
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
       print(dataFilePath)
        loadItem()
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
                let newItem = Item()
                newItem.title = safeAddedItem
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
    
    func saveItem(){
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArrey)
            try data.write(to: dataFilePath!)
        }catch{
            print ("error encoding item array, \(error)")
        }

        tableView.reloadData()
    }
    func loadItem() {
        if  let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArrey = try decoder.decode([Item].self, from: data)
            }catch{
                print("error decoding item array,\(error)")
            }
        }
        
    }
}

