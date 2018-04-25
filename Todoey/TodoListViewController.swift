//
//  ViewController.swift
//  Todoey
//
//  Created by Eric Magallon (Office) on 24/04/2018.
//  Copyright © 2018 Syndicat Professionnel des Pilotes Marseille-Fos. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

  var itemArray = ["Find Mike", "Buy Eggos", "Destory Demogorgon"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  // MARK - Tableview Datasource Methods
  // Nombre de lignes dans la table
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return itemArray.count
  }
  
  // Chargement du contenu d'une ligne du tableview
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
    
    cell.textLabel?.text = itemArray[indexPath.row]
    
    return cell
  }

  // MARK - Add New Item
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      // what will happen once the user clicks the Add Item button in our UIAlert
      // On ajoute la saisie au tableau
      self.itemArray.append(textField.text!)
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
    if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
    } else {
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    // Supprime la ligne sélectionnée
    tableView.deselectRow(at: indexPath, animated: true)
  }
}


