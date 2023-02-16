//
//  CategoryViewController.swift
//  Todoey
//
//  Created by hassan on 15/02/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    let realm = try! Realm()
    var categoryArray : Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "no category added yet "
        return cell
    }
    //MARK: - tableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    //MARK: - add button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFieldGlobal = UITextField()
        let alert = UIAlertController(title: "add category", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default) { action in
            if let safeName = textFieldGlobal.text , textFieldGlobal.text != ""{
                let newCategory = Category()
                newCategory.name = safeName
                
                self.save(category: newCategory)
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "write the category"
            textFieldGlobal = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    //MARK: - manupulation Methods
    func save (category: Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
        }
        catch{
            print("error while saving category\(error)")
        }
        tableView.reloadData()
    }
    func loadCategory( ){
         categoryArray = realm.objects(Category.self)
    }
}
