//
//  DataBaseManager.swift
//  ToDoData1
//
//  Created by Droadmin on 14/12/23.
//


import Foundation
import SQLite3
import UIKit

class DBManager {
    static let dbManager = DBManager()
    
    var db:OpaquePointer?
    
    private init(){}
    
    //MARK: - database document diractory me create karna
    func createDatabase() -> OpaquePointer?{
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Database.db")
        
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            print("Database connection opened successfully \(fileURL)")
            return db
        } else {
            print("Failed to open database connection")
            return nil
        }
    }
    // MARK: - created database me table create karna
    func createTable(){
        let tableQuery = "CREATE TABLE IF NOT EXISTS TodoList(Id INTEGER PRIMARY KEY,ProjectName TEXT,Description TEXT,CellSelectedDate TEXT,StartDate TEXT,EndDate TEXT,ProjectState TEXT);"
        var statement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, tableQuery, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE{
                print("student table created")
            }else{
                print("student table not created")
            }
            sqlite3_finalize(statement)
        } else{
            print("could not prepared")
        }
   
    }
    // MARK: - data database me insert karana
    func insert (projectName:String,description:String,selectedCellDate:String,startDate:String,endDate:String,ProjectState:String){
        let insertData = "INSERT INTO TodoList (ProjectName,Description,CellSelectedDate,StartDate,EndDate,ProjectState)VALUES(?, ?, ?, ?, ?, ?);"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, insertData, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (projectName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (description as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (selectedCellDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (startDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (endDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 6, (ProjectState as NSString).utf8String, -1, nil)


            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data inserted successfully.")
            } else {
                print("Failed to insert data into the database.")
            }
            
            let status = sqlite3_finalize(statement)
            print("Staus: \(status)")
        } else {
            print("Error preparing statement for insertion: \(String(cString: sqlite3_errmsg(db)))")
        }
    }
    // MARK: - Data database se fatch karna
    func readData() -> [ReadData] {
        var data: [ReadData] = []
        data.removeAll()
        let query = "SELECT * FROM TodoList"
        
        
        var statement: OpaquePointer? // SQLite Query execute karne ke liye istmal hota hai
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
            // sqlite3_step function ek row ko fetch karne ke liye istemal hota hai.
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = Int(sqlite3_column_int(statement, 0))
                let projectName = String(cString: sqlite3_column_text(statement, 1))
                let description = String(cString: sqlite3_column_text(statement, 2))
                let cellSelecteddate = String(cString: sqlite3_column_text(statement, 3))
                let startDate = String(cString: sqlite3_column_text(statement, 4))
                let endDate = String(cString: sqlite3_column_text(statement, 5))
                let projectState = String(cString: sqlite3_column_text(statement, 6))


                
                let todoData = ReadData(id: id, projectName: projectName, description: description, selectedCellDate: cellSelecteddate, startDate: startDate, endDate: endDate, projectState: projectState )
                data.append(todoData)
                
            }
            sqlite3_finalize(statement)
            
        } else {
            print("Failed to prepare query")
        }
        
        return data
    }
    func updateData(description: String,startDate:String,enDate:String,projectState:String,id: Int){
        let updateQuery = "UPDATE TodoList SET Description = ?, StartDate = ?, EndDate = ?, ProjectState = ? WHERE Id = ?"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (description as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (startDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (enDate as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (projectState as NSString).utf8String, -1, nil)

            sqlite3_bind_int(statement, 5, Int32(id))

            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("update successfually")
                
            } else {
                print("Failed to update data in the database.")
            }
            
            let status = sqlite3_finalize(statement)
            print("Status: \(status)")
        }
        
    }
}
