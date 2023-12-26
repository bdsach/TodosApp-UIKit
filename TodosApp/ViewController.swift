//
//  ViewController.swift
//  TodosApp
//
//  Created by Bandit Silachai on 9/11/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var todosList = [
        Todo(todo: "Find a DIY to do", completed: false ),
        Todo(todo: "Sleep for the whole day!!!", completed: false),
        Todo(todo: "Go theaters", completed: false),
    ]
    var tabelView = UITableView()
    
    var textField = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabelView.dataSource = self
        tabelView.delegate = self
        tabelView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = .systemBackground
        setupUI()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = todosList[indexPath.row].completed ? "\(todosList[indexPath.row].todo) is done": todosList[indexPath.row].todo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setupUI(){
        view.addSubview(tabelView)
        
        tabelView.translatesAutoresizingMaskIntoConstraints = false

        tabelView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tabelView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        tabelView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tabelView.topAnchor.constraint(equalTo: view.topAnchor,constant: 20).isActive = true
        tabelView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
         
    }
    
    @objc func todoTapped() {
        promptAddTodo()
    }
    
    func promptAddTodo() {
        let alert = UIAlertController(title: "Add Todo", message: "add some todo you want.", preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "Enter your todo"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main) { _ in
                alert.actions.first?.isEnabled = textField.text?.isEmpty == false
            }
        }
        
        let addTodoAction = UIAlertAction(title: "OK", style: .default, handler: { [weak alert] _ in
            guard let text = alert?.textFields![0].text else { return }
            
            if !text.isEmpty {
                self.todosList.append(Todo(todo: text,completed: false))
                self.tabelView.reloadData()
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
               print("Cancel tapped")
           })
        
        addTodoAction.isEnabled = false
        
        alert.addAction(addTodoAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemBackground

        let text = UILabel()
        text.text = "Todos List"
        text.font = .systemFont(ofSize: 36, weight: .heavy)
        
        let iconView = UIImageView(image: UIImage(systemName: "plus"))
        iconView.frame = CGRect(x: view.frame.width - 30, y: 10, width: 50, height: 50)
        
        
        view.addSubview(text)
        view.addSubview(iconView)
        
        text.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        text.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10).isActive = true
        iconView.centerXAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        iconView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(todoTapped))
        view.addGestureRecognizer(tapGesture)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
           
            print("Delete action tapped for row \(indexPath.row)")
            self.todosList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
            
        }
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeConfig.performsFirstActionWithFullSwipe = false
            
        return swipeConfig
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let success = UIContextualAction(style: .normal, title: "Done") { (action, view, completion) in
            
            self.todosList[indexPath.row] = Todo(todo: self.todosList[indexPath.row].todo, completed: true)
            tableView.reloadData()
            
            completion(true)
        }
        
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [success])
        swipeConfig.performsFirstActionWithFullSwipe = false
        
        return swipeConfig
    }
}

