//
//  MainViewController.swift
//  Xcode11Project
//
//  Created by Bin Shang on 2019/12/5.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

import UIKit
import SwiftExpand

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "MainViewController"
        UIApplication.shared.isNotificationsEnabled = true;

        
        let one = UserDefaults.standard["one", default: "111"]
        let two = UserDefaults.standard["two", default: [String].self]
        DDLog(one, two)
        
        let days = DateFormatter.getDateDays("2020-03-01", endTime: "2020-05-01")
        DDLog(days)
    }


}
