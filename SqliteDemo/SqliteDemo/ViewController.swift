//
//  ViewController.swift
//  SqliteDemo
//
//  Created by Genusys Inc on 6/23/22.
//

import UIKit

class ViewController: UIViewController {
    
    let todoTable : UITableView={
        let table = UITableView()
        return table
    }()
    
    let todoVM = TodoViewModel(repo: TodoRepoImp(db: SqliteDatabaseManager()))
    var todoList:[TodoModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        setUpTableView()
        setObserver()
    }
    func setNavBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(onAddBtnTouched))
        navigationItem.title = "Todo list"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear Todos", style: .done, target: self, action: #selector(onTouchClearAllTodos))
    }
    @objc func onTouchClearAllTodos()  {
        
        print("onTouchClearAllTodos")
    }
    @objc func onAddBtnTouched(){
        
        let alert = UIAlertController(title: "Add Todo", message: "Insert todo", preferredStyle: .alert)
        
        alert.addTextField { textField in
            
            textField.placeholder = "Todo ...."
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            guard let textF = alert.textFields?.first?.text, !textF.isEmpty else {
                print("Enter todo")
                return
            }
            let date = String(Date().formatted(date: .abbreviated, time: .shortened))
            let todo = TodoModel(todoId: "", todoName: textF, todoDate: date)
            self.addTodoList(todo)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    func addTodoList(_ todo:TodoModel){
        print(todo)
        let isSuccess = todoVM.addTodo(todo: todo)
        if isSuccess {
            print("Todo added successfully")
            self.setObserver()
        }else{
            print("Something went wrong!")
        }
    }
    
    func setObserver() {
        let todos = todoVM.getAllTodos()
        
        self.todoList = todos
        todoTable.reloadData()
    }
    
    func setUpTableView()  {
        todoTable.frame = view.bounds
        view.addSubview(todoTable)
        todoTable.delegate = self
        todoTable.dataSource = self
        todoTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func deleteTodoAction(_ todo:TodoModel) {
        print("deleteTodoAction")

    }
    func updateTodoAction(_ todo:TodoModel)  {
        print("updateTodoAction")
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell.textLabel?.text = todoList[indexPath.row].todoName
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            self.deleteTodoAction(self.todoList[indexPath.row])
            completion(true)
        }
        
        let updateAction = UIContextualAction(style: .normal, title: "Update") { _, _, completion in
            self.updateTodoAction(self.todoList[indexPath.row])
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction,updateAction])
    }
    
    
}

