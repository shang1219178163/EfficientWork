//
//  HomeViewController.m
//  Xcode11Project
//
//  Created by Bin Shang on 2019/12/5.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

#import "HomeViewController.h"

#import "Macro.h"
#import "UIView+Ext.h"
#import "NSArray+Ext.h"
#import "NSDictionary+Ext.h"

#import "DetailViewController.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, strong) UITableView *tableView;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"HomeViewController";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(hanleActon:)];

    [self setupUI];
    [self.tableView reloadData];
    
//    NSLog(@"%@ %@ %@", NSDate.date, NSStringFromSelector(_cmd), @"111");
//    NNLog(@"%@ %@", @"222", @"333");
//    DDLog(@"%@ %@", @"222", @"333");
//
//    NSDate *date = NSDate.date;
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    dateFormatter.timeZone = NSTimeZone.systemTimeZone;
//
//    NSInteger interval = [NSTimeZone.systemTimeZone secondsFromGMTForDate: date];
//    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
//    NSString *localeDateStr = [dateFormatter stringFromDate:localeDate];
//    NSLog(@"%@", localeDateStr);
        
    NSArray<NSString *> *list = @[@"1", @"2", @"3", @"4", ];
    NSArray *list1 = [list map:^id _Nonnull(NSString * _Nonnull obj, NSUInteger idx) {
        return @[obj];
    }];

    NSArray *list2 = [list compactMap:^id _Nonnull(NSString * _Nonnull obj, NSUInteger idx) {
        return obj;
    }];

    NSArray *list3 = [list1 compactMap:^id _Nonnull(NSArray *obj, NSUInteger idx) {
        return [obj map:^id _Nonnull(NSNumber * obj, NSUInteger idx) {
            return @(obj.integerValue *obj.integerValue);
        }];
    }];
    DDLog(@"%@ %@ %@", list1, list2, list3);
    
    
    
    NSDictionary<NSString *, NSString *> *dic = @{
        @"1" : @"11",
        @"2" : @"22",
        @"3" : @"33",
    };
    
//    NSDictionary *dic1 = [dic compactMapValues:^id _Nonnull(NSString * _Nonnull obj) {
//        return @(obj.integerValue + 100);
//    }];
//
//    NSDictionary *dic2 = [dic compactMapValues:^id _Nonnull(NSString * _Nonnull obj) {
//        return @(obj.integerValue > 20);
//    }];
//
//    NSDictionary *dic3 = [dic map:^NSDictionary * _Nonnull(NSString * _Nonnull key, NSString * _Nonnull obj) {
//        return @{[key stringByAppendingFormat:@"%@", @"_"] : [obj stringByAppendingFormat:@"%@", @"_"],
//        };
//    }];
//    DDLog(@"%@ %@ %@", dic1, dic2, dic3);
    
    
    NSString *value = dic.allKeys[3];
    
    NSMutableDictionary *mdic = @{@"aaa" : NSNull.null,
                                  NSNull.null : @"bbb"
    }.mutableCopy;
    
    NSString *tmp = nil;
    mdic[@"ccc"] = tmp;
    [mdic setObject:tmp forKey:@"aaa"];
    DDLog(@"_%@_%@_", value, mdic);

    [mdic removeObjectForKey:@"ddd"];

}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)hanleActon:(UIBarButtonItem *)sender {
    DetailViewController *controller = [[DetailViewController alloc]init];
    [self.navigationController pushViewController:controller animated:true];
}

#pragma mark -UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"{%@, %@}", @(indexPath.section), @(indexPath.row)];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UILabel alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.01;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UILabel alloc]init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark -funtions

- (void)setupUI {
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.tableView];
    
}

#pragma mark -layz

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
            tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.separatorInset = UIEdgeInsetsZero;
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            tableView.backgroundColor = UIColor.groupTableViewBackgroundColor;
            
            tableView.estimatedRowHeight = 0.0;
            tableView.estimatedSectionHeaderHeight = 0.0;
            tableView.estimatedSectionFooterHeight = 0.0;
            tableView.rowHeight = 50;
            
            tableView.dataSource = self;
            tableView.delegate = self;
            
            //背景视图
//            UIView *view = [[UIView alloc]initWithFrame:tableView.bounds];
//            view.backgroundColor = UIColor.cyanColor;
//            tableView.backgroundView = view;
//            tableView.bounces = NO;
            tableView;
        });
    }
    return _tableView;
}

@end
