//
//  Category.swift
//  Todoey
//
//  Created by Faraz Haider on 2/1/18.
//  Copyright © 2018 Faraz Haider. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name :String = ""
    let items = List<Item>()
}
