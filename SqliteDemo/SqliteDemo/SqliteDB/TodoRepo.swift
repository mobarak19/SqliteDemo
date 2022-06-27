
import Foundation

protocol TodoRepo {
    func addTodo(todo:TodoModel)->Bool
    func removeTodo(todo:TodoModel)->Bool
    func getTodoById(todoId:String)->TodoModel
    func updateTodo(todo:TodoModel)->TodoModel
    func deleteAllTodo()->Bool
    func getAllTodos()->[TodoModel]
    
}
