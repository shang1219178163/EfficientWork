//
//  HomeViewController.m
//  Xcode11Project
//
//  Created by Bin Shang on 2019/12/5.
//  Copyright © 2019 Bin Shang. All rights reserved.
//

#import "HomeViewController.h"

#ifdef DEBUG
#define NNLog(fmt, ...) NSLog((@"[Line %d] %s " fmt), __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__);

#else
#define NNLog(...)
#endif


#ifdef DEBUG
#define DDLog(FORMAT, ...) {\
NSString *formatStr = @"yyyy-MM-dd HH:mm:ss.SSSSSSZ";\
NSMutableDictionary *threadDic = NSThread.currentThread.threadDictionary;\
NSDateFormatter *formatter = [threadDic objectForKey:formatStr];\
if (!formatter) {\
formatter = [[NSDateFormatter alloc]init];\
formatter.dateFormat = formatStr;\
[threadDic setObject:formatter forKey:formatStr];\
}\
NSString *str = [formatter stringFromDate:NSDate.date];\
fprintf(stderr,"%s【line %d】%s %s\n",[str UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
}

#else
#define DDLog(...)
#endif


@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) NSMutableArray *dataList;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"HomeViewController";

    [self setupUI];
    [self.tableView reloadData];
    
    NSLog(@"%@ %@ %@", NSDate.date, NSStringFromSelector(_cmd), @"111");
    NNLog(@"%@ %@", @"222", @"333");
    DDLog(@"%@ %@", @"222", @"333");

    NSDate *date = NSDate.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.timeZone = NSTimeZone.systemTimeZone;
    
    NSInteger interval = [NSTimeZone.systemTimeZone secondsFromGMTForDate: date];
    NSDate *localeDate = [date dateByAddingTimeInterval: interval];
    NSString *localeDateStr = [dateFormatter stringFromDate:localeDate];
    NSLog(@"%@", localeDateStr);
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
