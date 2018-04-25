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
  
  // Chemin vers le fichier
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print(dataFilePath!)

    // On charge les données depuis le fichier plist
    loadItems()
    
    //if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
    //  itemArray = items
    //}
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
  
  // MARK - Tableview Delegate Methods
  
  // Sélection d'une ligne
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //print(itemArray[indexPath.row])
    
    // Gère la case à cocher
    // On utilise l'opposé au lieu de tester la valeur pour assigner son contraire
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    
    // On sauve sur le téléphone
    saveItems()
    
    // Supprime la sélection de la ligne
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  // MARK - Model Manipulation Methods
  
  func saveItems() {
    // On sauve les items (persistence)
    let encoder = PropertyListEncoder()
    
    do {
      let data = try encoder.encode(itemArray)
      try data.write(to: dataFilePath!)
    } catch {
      print("Error encoding item array \(error)")
    }
    
    // On recharge la table view
    self.tableView.reloadData()
  }
  
  func loadItems() {
    if let data = try? Data(contentsOf: dataFilePath!) {
      let decoder = PropertyListDecoder()
      
      do {
        itemArray = try decoder.decode([Item].self, from: data)
      } catch {
        print("Error during load of data, \(error)")
      }
    }
  }
}


