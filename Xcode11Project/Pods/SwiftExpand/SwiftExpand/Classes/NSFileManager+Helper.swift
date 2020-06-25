//
//  NSFileManager+Helper.swift
//  IntelligentOfParking
//
//  Created by Bin Shang on 2020/2/14.
//  Copyright © 2020 Xi'an iRain IoT. Technology Service CO., Ltd. . All rights reserved.
//

import UIKit

public extension FileManager{

    ///读取本地文件内容
    static func readFile(forResource name: String?, ofType ext: String?) -> String{
        let path = Bundle.main.path(forResource: name, ofType: ext)
        do {
            let content = try String(contentsOfFile: path!)
            return content

        } catch {
            print(error)
            // Handle the error
        }
        return ""
    }
    
}
