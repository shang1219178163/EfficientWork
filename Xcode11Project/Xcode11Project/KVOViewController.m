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


@property(nonatomic, strong) id localeChangeObserver;

@end


@implementation KVOViewController

- (void)dealloc{
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [NSNotificationCenter.defaultCenter removeObserver:self.localeChangeObserver];
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
    
    NSNotificationCenter * __weak center = NSNotificationCenter.defaultCenter;
    self.localeChangeObserver = [center addObserverForName:NSCurrentLocaleDidChangeNotification
                                                    object:nil
                                                     queue:NSOperationQueue.mainQueue
                                                usingBlock:^(NSNotification *note) {
     
        NSLog(@"The user's locale changed to: %@", NSLocale.currentLocale.localeIdentifier);
    }];
}

-(void)scan{
    NSNotificationCenter * __weak center = NSNotificationCenter.defaultCenter;
    __block id observer = [center addObserverForName:@"ScanComplete"
                                              object:nil
                                               queue:nil
                                          usingBlock:^(NSNotification *note){
        /*
         do something
         */
        [center removeObserver:observer];
    }];
}


@end
