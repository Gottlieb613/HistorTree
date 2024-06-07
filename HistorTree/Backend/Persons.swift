//
//  persons.swift
//  HistorTree
//
//  Created by Charlie Gottlieb on 6/3/24.
//

import Foundation
import SQLite
import UIKit


class PersonsDatabaseManager: ObservableObject {
    
    var db: Connection!
    
    let persons = Table("persons")
    let first_exp = Expression<String>("name_first")
    let last_exp = Expression<String>("name_last")
    let gender_exp = Expression<Bool>("gender")
    let birth_year_exp = Expression<Int64>("birth_year")
    
    init() {
        setupDatabase()
    }
    
    func setupDatabase() {
        do {
            let dbPath = try! FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("appDatabase.sqlite")
                .path
            
            db = try! Connection(dbPath)
            
            try db?.run(persons.create(ifNotExists: true) { t in
                t.column(Expression<Int64>("id"), primaryKey: true);
                t.column(first_exp);
                t.column(last_exp);
                t.column(Expression<String?>("name_last_maiden"), defaultValue: nil);
                t.column(gender_exp); //true=male, false=female
                t.column(birth_year_exp);
                t.column(Expression<Int64?>("birth_month"), defaultValue: nil);
                t.column(Expression<Int64?>("birth_day"), defaultValue: nil);
                t.column(Expression<Int64?>("deat_year"), defaultValue: nil);
                t.column(Expression<Int64?>("death_month"), defaultValue: nil);
                t.column(Expression<Int64?>("death_day"), defaultValue: nil);
                t.column(Expression<Date>("created_at"), defaultValue: Date())
            })
        } catch {
            print("Error setting up database: \(error)")
        }
    }
    
    func insertUser(name_first: String, name_last: String, gender: Bool, birth_year: Int64) {
        print("DEBUG inserting \(name_first) \(name_last)")
        do {
           
            
            let insertion = persons.insert(first_exp <- name_first, last_exp <- name_last, gender_exp <- gender, birth_year_exp <- birth_year)
            try db.run(insertion)
        } catch {
            print("Error inserting user: \(error)")
        }
    }
    
    func queryUsers() {
        print("DEBUG querying users")
        do {
            let id = Expression<Int64>("id")
            
            for person in try db.prepare(persons) {
                print("id: \(person[id]), Name: \(person[first_exp]) \(person[last_exp]). Gender: \(person[gender_exp] ? "male" : "female"). Born in \(person[birth_year_exp])")
            }
            
        } catch {
            print("Error querying users: \(error)")
        }
        
    }
}
