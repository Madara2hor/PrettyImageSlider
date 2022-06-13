//
//  NSObject.swift
//  tabBar
//
//  Created by Кирилл on 13.06.2022.
//

import Foundation

internal extension NSObject {
    
    func copyObject<T: NSObject>() throws -> T? {
        let data = try NSKeyedArchiver.archivedData(withRootObject:self, requiringSecureCoding:false)
        return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
    }
}
