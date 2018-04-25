//
//  ViewController.swift
//  Todoey
//
//  Created by Eric Magallon (Office) on 24/04/2018.
//  Copyright © 2018 Syndicat Professionnel des Pilotes Marseille-Fos. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

  // Tableau de la todo list
  var itemArray = [Item]()
  
  let defaults = UserDefaults.standard
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let newItem = Item()
    newItem.title = "Find Mike"
    itemArray.append(newItem)
    
    let newItem2 = Item()
    newItem2.title = "Buy Eggos"
    itemArray.append(newItem2)
    
    let newItem3 = Item()
    newItem3.title = "Destroy Demogorgon"
    itemArray.append(newItem3)
    
    // On charge les données depuis le fichier plist
    if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
      itemArray = items
    }
  }

  // MARK - Tableview Datasource Methods
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

  // MARK - Add New Item
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // what will happen once the user clicks the Add Item button in our UIAlert
      // On ajoute la saisie au tableau
      let newItem = Item()
      newItem.title = textField.text!
      
      self.itemArray.append(newItem)
      
      // On sauve l'item (persistence)
      self.defaults.set(self.itemArray, forKey: "TodoListArray")
      
      // On recharge la table view
      self.tableView.reloadData()
    }
    
    // Paramétrage du message d'alerte pour lire la saisie
    alert.addTextField { (alertTextField) in
      alertTextField.placeholder = "Create new item"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
  }
  
  // MARK - Tableview Delegate Methods
  
  // Sélection d'une ligne
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //print(itemArray[indexPath.row])
    
    // Gère la case à cocher
    // Onn utilise l'opposé au lieu de tester la valeur pour assigner son contraire
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    /*
    if itemArray[indexPath.row].done == false {
      itemArray[indexPath.row].done = true
    } else {
      itemArray[indexPath.row].done = false
    } */
    
    // On recharge le tableau
    tableView.reloadData()
    
    // Supprime la sélection de la ligne
    tableView.deselectRow(at: indexPath, animated: true)
  }
}


