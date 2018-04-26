//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Eric Magallon (Office) on 26/04/2018.
//  Copyright © 2018 Syndicat Professionnel des Pilotes Marseille-Fos. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    // Déclarations
    // Tableau des catégories pour l'affichage
    var categoryArray = [Category]()
    // Contexte pour la sauvegarde des données
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // On charge les données
        loadCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }*/
    
    // MARK: Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button in our UIAlert
            // On ajoute la saisie au tableau
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            // On ajoute l'item au tableau
            self.categoryArray.append(newCategory)
            
            // On sauve sur le téléphone
            self.saveCategory()
        }
        
        // Paramétrage du message d'alerte pour lire la saisie
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
  
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // On déclare la cellule
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // On affecte la catégorie depuis le tableau représentant l'entity
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        // On renvoie la cellule
        return cell
    }
    
    //MARK: - TableView Delegate Methods
  
    // Sélection d'une ligne pour passer à l'écran de la todo list pour cette catégorie
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func saveCategory() {
        // On sauve les categories (persistence)
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        // On recharge la table view
        tableView.reloadData()
    }
  
}
