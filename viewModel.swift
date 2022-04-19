//
//  viewModel.swift
//  Habit Management
//
//  Created by 한수진 on 2022/04/18.
//

import Foundation
import RealmSwift

class viewModel: ObservableObject {
    
    @Published var habit: Habits? = nil
    var token: NotificationToken? = nil

    var realm: Realm?

    init(){
        let realm = try? Realm()
        self.realm = realm

        if let group = realm?.objects(Habits.self).first {
            self.habit = group
        }else {
            
            try? realm?.write({
                let group = Habits()
                realm?.add(group)

            })
        }
        
        token = habit?.observe({ (changes) in
            switch changes {
            case .error(_): break
                
//            case .initial(_): break
//            case .update(_, deletions: _, insertions: _, modifications: _):
//                self.objectWillChange.send()
            case .change(_, _):
                break
            case .deleted:
                break
            }
        })
    }
    
    func addItem(name: String, iter: [Int]){
        
        if name != "", let realm = habit?.realm{
            try? realm.write{
                realm.add(Habits(name: name, iter: iter))

        }
        }

    }

}
