//
//  Data.swift
//  Todoey
//
//  Created by hassan on 16/02/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
