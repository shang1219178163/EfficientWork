//
//  UIResponder+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2020/5/20.
//  Copyright © 2020 BN. All rights reserved.
//

import UIKit

@objc public extension UIResponder {

    func responderChain() -> String {
        guard let next = next else {
            return String(describing: self)
        }
        return String(describing: self) + " -> " + next.responderChain()
    }

}
