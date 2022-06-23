//
//  TodoViewModel.swift
//  SqliteDemo
//
//  Created by Genusys Inc on 6/23/22.
//

import Foundation

class TodoViewModel{
   private var repo : TodoRepoImp?
    init(repo:TodoRepoImp) {
        self.repo = repo
    }
    
    
    func addTodo(todo:TodoModel)->Bool{
        return repo?.addTodo(todo: todo) ?? false
    }
    
    func getAllTodos()->[TodoModel]{
        return repo?.getAllTodos() ?? []
    }
    
}
