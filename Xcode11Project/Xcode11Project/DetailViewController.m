//
//  DetailViewController.m
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/11.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "DetailViewController.h"
#import "KVOViewController.h"

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

@end
