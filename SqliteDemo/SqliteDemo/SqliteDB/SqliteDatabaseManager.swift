

import Foundation
import SQLite3
class SqliteDatabaseManager{
    private let DB_PATH = "tododb.sqlite"
    private var db : OpaquePointer?
    private var createTodoTableQuery = ""
    private let todoTableName = "todo_table"
    
    init() {
        
        self.createTodoTableQuery =
        "CREATE TABLE IF NOT EXISTS " +
        todoTableName +
        " (" +
        TodoModelName.todoId +
        " INTEGER PRIMARY KEY AUTOINCREMENT , " +
        TodoModelName.todoName +
        " text , " +
        TodoModelName.todoDate +
        " text)"
        
        self.db = openDatabase()
        self.createTodoTable()
    }
    
    func openDatabase()->OpaquePointer?{
        
        var db: OpaquePointer?
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(DB_PATH)
     
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK {
            return nil
        }else{
            return db
        }
    }
    
    func createTodoTable(){
        var createTodoTableStatement:OpaquePointer?
        if sqlite3_prepare_v2(self.db, createTodoTableQuery, -1, &createTodoTableStatement, nil) == SQLITE_OK{
            if sqlite3_step(createTodoTableStatement) == SQLITE_DONE {
                
                print("Todo table created")
                
            }else{
                print("Todo table is not created")
            }
            
        }else{
            print("create table statement is not prepared")
        }
        sqlite3_finalize(createTodoTableStatement)
    }
    
    func insetTodo(todo:TodoModel)->Bool{
        var insertOpaquePointer: OpaquePointer?
        
        let insertQuery = "INSERT INTO \(todoTableName) (\(TodoModelName.todoName),\(TodoModelName.todoDate)) VALUES(?,?)"
        
        if sqlite3_prepare_v2(self.db, insertQuery, -1, &insertOpaquePointer, nil)==SQLITE_OK{
            
            sqlite3_bind_text(insertOpaquePointer, 1, (todo.todoName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertOpaquePointer,2, (todo.todoDate as NSString).utf8String, -1, nil)
            if sqlite3_step(insertOpaquePointer) == SQLITE_DONE{
                sqlite3_finalize(insertOpaquePointer)
                print("row inserted")

                return true
            }else{
                sqlite3_finalize(insertOpaquePointer)
                print("could not insert row")

                return false
            }
            
        }else{
            print("Inset statement is not prepared")
            sqlite3_finalize(insertOpaquePointer)

            return false
        }
        
    }
    
    func getAllTodos()->[TodoModel]{
        var getAllOpaquePointer : OpaquePointer?
        let getAllQuery = "SELECT * FROM \(todoTableName)"
        
        var todos :[TodoModel] = []
        if sqlite3_prepare_v2(self.db, getAllQuery, -1, &getAllOpaquePointer, nil) == SQLITE_OK {
            while sqlite3_step(getAllOpaquePointer) == SQLITE_ROW{
                let id = sqlite3_column_int(getAllOpaquePointer, 0)
                let todoName:String = String(describing: String(cString: sqlite3_column_text(getAllOpaquePointer, 1)))
                let date = String(describing: String(cString: sqlite3_column_text(getAllOpaquePointer, 2)))
                todos.append(TodoModel(todoId: String(id), todoName: todoName, todoDate: date))
            }
            sqlite3_finalize(getAllOpaquePointer)
            return todos
        }else{
            sqlite3_finalize(getAllOpaquePointer)
            return []
        }
    }
}
