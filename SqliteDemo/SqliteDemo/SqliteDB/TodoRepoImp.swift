//
//  TodoRepoImp.swift
//  SqliteDemo
//
//  Created by Genusys Inc on 6/23/22.
//

import Foundation

class TodoRepoImp:TodoRepo{
    private var db:SqliteDatabaseManager?
    init(db:SqliteDatabaseManager) {
        
        self.db = db
    }
    
    func addTodo(todo: TodoModel) -> Bool {
        return self.db?.insetTodo(todo: todo) ?? false
    }
    
    func removeTodo(todo: TodoModel) -> Bool {
        return false

    }
    
    func getTodoById(todoId: String) -> TodoModel {
        return TodoModel(todoId: "", todoName: "", todoDate: "")
    }
    
    func updateTodo(todo: TodoModel) -> TodoModel {
        return TodoModel(todoId: "", todoName: "", todoDate: "")

    }
    
    func deleteAllTodo() -> Bool {
        
        return false

    }
    func getAllTodos() -> [TodoModel] {
        return self.db?.getAllTodos() ?? []

    }
    
    
}
