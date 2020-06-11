//
//  KVOViewController.m
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/11.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "KVOViewController.h"
#import "NSObject+KVO.h"
#import "Person.h"

@interface KVOViewController ()

@property(nonatomic, strong) Person *person;

@property(nonatomic, strong) NSString *string;

@end


@implementation KVOViewController

- (void)dealloc{
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.person = [[Person alloc] init];
    self.person.name = @"zhangsan";
    self.person.score = @84;

    [self.person addKVOObserver:self keyPath:@"name" block:^(NSString * _Nonnull keyPath, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"%@_%@", keyPath, change);
    }];
    
    [self.person addKVOObserver:self keyPath:@"score" block:^(NSString * _Nonnull keyPath, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"%@_%@", keyPath, change);
    }];
    self.person.name = @"lisi";
    self.person.score = @65; // 重新给分数赋值时会执行block 内的处理
    
    [self addKVOObserver:self keyPath:@"string" block:^(NSString * _Nonnull keyPath, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"%@_%@", keyPath, change);
    }];
    self.string = @"788";
}


@end
