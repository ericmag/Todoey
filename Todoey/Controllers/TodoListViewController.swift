//
//  ViewController.swift
//  Todoey
//
//  Created by Eric Magallon (Office) on 24/04/2018.
//  Copyright © 2018 Syndicat Professionnel des Pilotes Marseille-Fos. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    // Tableau de la todo list
    var itemArray = [Item]()
    
    // dès que cette variable sera renseignée (par le segue de l'écran précédent), on peut charger les tâches pour cette catégorie
    var selectedCategory: Category? {
        didSet {
            // On charge la liste des tâches pour cette catégorie
            loadItems()
        }
    }
    
    // Contexte pour core data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // On charge les données depuis le core data
        //loadItems()
        
        //if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //  itemArray = items
        //}
    }
    
    // MARK: Tableview Datasource Methods
    // Nombre de lignes dans la table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // Chargement du contenu d'une ligne du tableview
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // On récupère l'état de la case à cocher du tableau
        // Ternary operator
        // value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        /*if item.done == true {
         cell.accessoryType = .checkmark
         } else {
         cell.accessoryType = .none
         } */
        
        return cell
    }
    
    // Effacement par glisser déplacer
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // On efface la ligne du contexte
        
        context.delete(itemArray[indexPath.row])
        // On efface la ligne du tableau
        itemArray.remove(at: indexPath.row)
        // On sauve le contexte et on recharge la table view
        saveItems()
    }
    
    // MARK: Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button in our UIAlert
            // On ajoute la saisie au tableau
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            // On ajoute l'item au tableau
            self.itemArray.append(newItem)
            
            // On sauve sur le téléphone
            self.saveItems()
        }
        
        // Paramétrage du message d'alerte pour lire la saisie
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Tableview Delegate Methods
    
    // Sélection d'une ligne
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Gère la case à cocher
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        // On utilise l'opposé au lieu de tester la valeur pour assigner son contraire
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // On sauve sur le téléphone
        saveItems()
        
        // Supprime la sélection de la ligne
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Model Manipulation Methods
    
    func saveItems() {
        // On sauve les items (persistence)
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        // On recharge la table view
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            // si le champ de recherche est renseigné, on a un une double recherche
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        } else {
            // On ne filtre que sur la catégorie
            request.predicate = categoryPredicate
        }
        
        //let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        //request.predicate = compoundPredicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
}

// MARK: Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // On créé la requête sur l'entity Item du modèle
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // Construction du filtre
        // [cd] pour ne pas être sensible à la casse ou aux accents
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // Tri
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // Debug
        print("Requête : \n(request.predicate)")
        
        // On exécute la requête
        loadItems(with: request, predicate: predicate)
    }
    
    // Dans le cas où on vide la barre de recherche
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // On fait disparaître le clavier en même temps que l'on charge les données
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}


