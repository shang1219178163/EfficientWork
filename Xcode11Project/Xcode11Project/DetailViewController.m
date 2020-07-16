//
//  DetailViewController.m
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/11.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "DetailViewController.h"
#import "KVOViewController.h"
#import "UIView+Ext.h"
#import "UIResponder+Ext.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Detail";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(hanleActon:)];
}

- (void)hanleActon:(UIBarButtonItem *)sender {
    KVOViewController *controller = [[KVOViewController alloc]init];
    [self.navigationController pushViewController:controller animated:true];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
}

//-(UIResponder *)findNextResponder:(NSString *)responderName{
//    UIResponder *next = self.nextResponder;
//    while (next){
//        if ([next isKindOfClass:[NSClassFromString(responderName) class]]){
//            return next;
//        }
//        next = [next nextResponder];
//    }
//    return nil;
//}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UIResponder *next = self.nextResponder;
//    NSMutableString *prefix = @"--".mutableCopy;
//    NSLog(@"%@", self.class);
//
//    while (next) {
//        NSLog(@"%@%@", prefix, next.class);
//        [prefix appendString: @"--"];
//        next = [next nextResponder];
//    }
    
    NSLog(@"_%@_", [self nextResponder:@"UINavigationController"]);

}

@end
