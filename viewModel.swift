//
//  viewModel.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/18.
//

import Foundation
import RealmSwift
import SwiftUI

class viewModel: ObservableObject {
    
//    @Published var habit: Habits? = nil
//    @Published var result: [Habits]? = nil
    
    @Published var result: [Habits] = []
    
    var habit: Results<Habits>?
    var token: NotificationToken? = nil

    var realm: Realm?

    init(){
        
        print("view model init")
        
        let realm = try? Realm()
        self.realm = realm
        fetchItem()

        if let group = realm?.objects(Habits.self) {
            self.habit = group

        }else {
            
            try? realm?.write({
                let group = Habits()
                realm?.add(group)

            })
        }
        
        token = habit?.observe({ (changes) in
            switch changes {
            case .error(_):
                print("error")
                break
    
            case .initial(_):
                print("initial")
                
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                print("update")
//                self.objectWillChange.send()

            }
        })
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)

    }
    
    func addItem(name: String, iter: [Int]){
        
        if name != "", let realm = habit?.realm{
            try? realm.write{
                realm.add(Habits(name: name, iter: iter))
                fetchItem()
            }
        }

    }
    
    func deleteItem(at habit: Habits){
        try! realm?.write {
            realm?.delete(habit)
            fetchItem()
        }
    }
    
    public func fetchItem(){
        result = (NSArray(array: Array(realm!.objects(Habits.self))) as? [Habits])!

    }
    
}
