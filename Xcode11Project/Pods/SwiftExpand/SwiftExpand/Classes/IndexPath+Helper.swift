//
//  IndexPath+Helper.swift
//  SwiftExpand
//
//  Created by Bin Shang on 2019/12/2.
//

import UIKit

    
public extension NSIndexPath{
    /// {section, row}
    var string: String {
        return String(format: "{%d, %d}", section, row)
    }

}

    
public extension IndexPath{
    /// {section, row}
    var string: String {
        return String(format: "{%d, %d}", section, row)
    }

}
