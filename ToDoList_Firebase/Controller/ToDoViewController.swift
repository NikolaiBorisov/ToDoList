//
//  ToDoViewController.swift
//  ToDoList_Firebase
//
//  Created by NIKOLAI BORISOV on 25.03.2021.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var todoTV: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var todos: [Todo] = []
    var userId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setWelcomeLabel()
        
        todoTV.delegate = self
        todoTV.dataSource = self
        todoTV.rowHeight = 80
        
        loadTodos()
    }
    
    func setWelcomeLabel() {
        let userRef = Database.database().reference(withPath: "users").child(userId!)
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let email = value!["email"] as? String
            self.welcomeLabel.text = "Hello, " + email! + " !"
        }
    }
    
    @IBAction func lodoutAction(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTodos(_ sender: Any) {
        
        let todoAlert = UIAlertController(title: "New Todo", message: "Add a todo", preferredStyle: .alert)
        todoAlert.addTextField()
        let addTodoAction = UIAlertAction(title: "Add", style: .default) { (action) in
            let todoText = todoAlert.textFields![0].text
            guard let text = todoAlert.textFields?.first, !text.text!.isEmpty else { return }
            self.todos.append(Todo(isChecked: false, todoName: todoText!))
            let ref = Database.database().reference(withPath: "users").child(self.userId!).child("todos")
            ref.child(todoText!).setValue(["isChecked": false])
            self.todoTV.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        todoAlert.addAction(addTodoAction)
        todoAlert.addAction(cancelAction)
        
        present(todoAlert, animated: true, completion: nil)
    }
    
    
    func loadTodos() {
        let ref = Database.database().reference(withPath: "users").child(userId!).child("todos")
        ref.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let todoName = child.key
                let todoRef = ref.child(todoName)
                
                todoRef.observeSingleEvent(of: .value) { (todoSnapshot) in
                    let value = todoSnapshot.value as? NSDictionary
                    let isChecked = value!["isChecked"] as? Bool
                    self.todos.append(Todo(isChecked: isChecked!, todoName: todoName))
                    self.todoTV.reloadData()
                }
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoTableViewCell
        
        cell.todoLabel.text = todos[indexPath.row].todoName
        
        if todos[indexPath.row].isChecked {
            cell.checkMarkImage.image = UIImage(named: "FNote")
        } else {
            cell.checkMarkImage.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ref = Database.database().reference(withPath: "users").child(userId!).child("todos").child(todos[indexPath.row].todoName)
        
        if todos[indexPath.row].isChecked {
            todos[indexPath.row].isChecked = false
            ref.updateChildValues(["isChecked": false])
        } else {
            todos[indexPath.row].isChecked = true
            ref.updateChildValues(["isChecked": true])
        }
        
        todoTV.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let ref = Database.database().reference(withPath: "users").child(userId!).child("todos").child(todos[indexPath.row].todoName)
            
            ref.removeValue()
            todos.remove(at: indexPath.row)
            todoTV.reloadData()
        }
    }

}
