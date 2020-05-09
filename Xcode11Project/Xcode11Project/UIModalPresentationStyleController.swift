//
//  UIModalPresentationStyleController.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/12/5.
//  Copyright © 2019 BN. All rights reserved.
//

import UIKit
import SwiftExpand

class UIModalPresentationStyleController: UIViewController{
    
    lazy var tableView: UITableView = {
        let table: UITableView = UITableView(frame: self.view.bounds, style: .plain)
        table.dataSource = self
        table.delegate = self

        return table
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1.设置行高为自动撑开
        tableView.rowHeight = UITableView.automaticDimension;
       // 2.设置一个估计的行高，只要大于0就可以了，但是还是尽量要跟cell的高差不多
        tableView.estimatedRowHeight = 100;
       // 3.走完了以上两步就不需要走 UITableViewDelegate 返回行高的那个代理了
        view.addSubview(tableView)
        
        if title == nil {
            title = self.controllerName;
        }
        
        view.getViewLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -funtions
    

    lazy var list: [[String]] = {
        var array: [[String]] =
            [["UIModalPresentationFullScreen", "由下到上,全屏覆盖", ],
            ["UIModalPresentationPageSheet", "在portrait时是FullScreen，在landscape时和FormSheet模式一样", ],
            ["UIModalPresentationFormSheet", "会将窗口缩小，使之居于屏幕中间。在portrait和landscape下都一样，但要注意landscape下如果软键盘出现，窗口位置会调整。", ],
            ["UIModalPresentationCurrentContext", "这种模式下，presented VC的弹出方式和presenting VC的父VC的方式相同。", ],
            ["UIModalPresentationCustom", "自定义视图展示风格,由一个自定义演示控制器和一个或多个自定义动画对象组成。符合UIViewControllerTransitioningDelegate协议。使用视图控制器的transitioningDelegate设定您的自定义转换。", ],
            ["UIModalPresentationOverFullScreen", "如果视图没有被填满,底层视图可以透过", ],
            ["UIModalPresentationOverCurrentContext", "视图全部被透过", ],
            ["UIModalPresentationPopover", "--", ],
            ["UIModalPresentationNone", "--", ],
        ]
        return array
    }()
}

extension UIModalPresentationStyleController: UITableViewDataSource, UITableViewDelegate{
    //    MARK: - tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count;
    };
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension;
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let itemList = list[indexPath.row]
        
        let cell = UITableViewCell.dequeueReusableCell(tableView, identifier: "cell1", style: .subtitle);
        
        cell.accessoryType = .disclosureIndicator;
        
        cell.textLabel!.text = itemList[0]
        cell.textLabel!.textColor = UIColor.theme;
        cell.detailTextLabel!.text = itemList[1];
        cell.detailTextLabel!.textColor = UIColor.gray;
        cell.detailTextLabel!.numberOfLines = 0;
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)//不加此行,视图展示会很慢
        
        let itemList = list[indexPath.row]
        DDLog(itemList);
        
        let controller = UIViewController()
        controller.modalPresentationStyle = UIModalPresentationStyle(rawValue: indexPath.row)!
        DDLog(controller.presentedViewController, controller.presentationController)
        self.present(controller, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView();
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01;
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel(frame: .zero);
        //        label.backgroundColor = .green;
        //        label.text = "header\(section)";
        return label;
    }
}
