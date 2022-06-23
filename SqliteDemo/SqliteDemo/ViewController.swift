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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .done, target: self, action: #selector(onAddBtnTouched))
        navigationItem.title = "Todo list"
    }

    @objc func onAddBtnTouched(){
        print("onAddBtnTouched")
        
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
    
    
    
}

