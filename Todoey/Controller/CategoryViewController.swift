//
//  CategoryViewController.swift
//  Todoey
//
//  Created by hassan on 15/02/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    //MARK: - tableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    //MARK: - add button
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textFieldGlobal = UITextField()
        let alert = UIAlertController(title: "add category", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "add", style: .default) { action in
            if let safeName = textFieldGlobal.text , textFieldGlobal.text != ""{
                let newCategory = Category(context: self.context)
                newCategory.name = safeName
                self.categoryArray.append(newCategory)
                self.saveCategory()
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
    func saveCategory () {
        
        do{
            try context.save()
        }
        catch{
            print("error while saving category\(error)")
        }
        tableView.reloadData()
    }
    func loadCategory( request : NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("error while load category\(error)")
        }
        tableView.reloadData()
    }
}
