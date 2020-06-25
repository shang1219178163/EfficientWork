//
//  SudokuViewController.m
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/25.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "SudokuViewController.h"
#import "Masonry.h"
#import "MasonryExtend.h"

#import "Macro.h"
#import "UIView+Ext.h"
#import "UIButton+Ext.h"


@interface SudokuViewController ()

@end

@implementation SudokuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Sudoku";
        
//    NSArray *list = [self.view updateItems:9 aClassName:@"NXButton" handler:^(UIView * _Nonnull obj) {
//        if (![obj isKindOfClass:UIButton.class]) {
//            return;
//        }
//        NSString *clsName = NSStringFromClass(obj.class);
//        UIButton *sender = (UIButton *)obj;
//        sender.titleLabel.font = [UIFont systemFontOfSize:15];
//        NSString *title = [NSString stringWithFormat:@"%@%@", clsName, @(obj.tag)];
//        [sender setTitle:title forState:UIControlStateNormal];
//        [sender setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
//        [sender setBackgroundColor:UIColor.whiteColor forState:UIControlStateNormal];
//        [sender setBackgroundColor:UIColor.systemBlueColor forState:UIControlStateHighlighted];
//        [sender setBackgroundColor:UIColor.grayColor forState:UIControlStateDisabled];
//    }];
    
    NSArray *list = [self.view updateButtonItems:9 aClassName:@"NXButton" handler:^(__kindof UIButton * _Nonnull obj) {
        [obj setBackgroundColor:UIColor.whiteColor forState:UIControlStateNormal];
        [obj setBackgroundColor:UIColor.systemBlueColor forState:UIControlStateHighlighted];
        [obj setBackgroundColor:UIColor.grayColor forState:UIControlStateDisabled];
    }];

    [list mas_distributeSudokuViewsWithFixedLineSpacing:5
                                  fixedInteritemSpacing:5
                                              warpCount:3
                                                  inset:UIEdgeInsetsMake(10, 10, 10, 10)];
    
//    [list mas_distributeSudokuViewsWithFixedItemWidth:120
//                                      fixedItemHeight:120
//                                            warpCount:3
//                                                inset:UIEdgeInsetsMake(10, 10, 10, 10)];

    self.view.backgroundColor = UIColor.systemGreenColor;
}



@end
