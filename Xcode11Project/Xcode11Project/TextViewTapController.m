//
//  TextViewTapController.m
//  2222
//
//  Created by Bin Shang on 2020/4/16.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "TextViewTapController.h"

@interface TextViewTapController ()<UITextViewDelegate>

@end

@implementation TextViewTapController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"TextViewTap";
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.view.bounds) - 20, 180)];
    textView.font = [UIFont systemFontOfSize:16];
    
    NSArray *tapTexts = @[@"《用户协议》", @"《隐私政策》", ];
    NSArray *tapUrls = @[@"", @"", ];

    NSString *string = [NSString stringWithFormat:@"\t用户协议和隐私政策请您务必审值阅读、充分理解 “用户协议” 和 ”隐私政策” 各项条款，包括但不限于：为了向您提供即时通讯、内容分享等服务，我们需要收集您的设备信息、操作日志等个人信息。\n\t您可阅读%@和%@了解详细信息。如果您同意，请点击 “同意” 开始接受我们的服务;", tapTexts[0], tapTexts[1]];
    
    NSDictionary *attDic = @{
        NSForegroundColorAttributeName: UIColor.grayColor,
        NSFontAttributeName: textView.font,
    };
    
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string attributes:attDic];
    
    [tapTexts enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *value = [NSString stringWithFormat:@"%@://%@", @(idx), tapUrls[idx]];//斜杠之后不能为中文
        [attString addAttribute:NSLinkAttributeName
                          value:value
                          range:[attString.string rangeOfString:obj]];
    }];

    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                 NSUnderlineColorAttributeName: [UIColor lightGrayColor],
//                                 NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)
                                     
    };

    // assume that textView is a UITextView previously created (either by code or Interface Builder)
    textView.linkTextAttributes = linkAttributes; // customizes the appearance of links
    textView.attributedText = attString;
    textView.delegate = self;
    textView.selectable = true;
    textView.editable = false;
    
    [self.view addSubview:textView];
    
    NSArray *list = [self getDatesWithStartDate:@"2020-03-01" endDate:@"2020-05-01"];
    NSLog(@"%@", list);
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSLog(@"%@", URL.absoluteString);
    if ([URL.scheme isEqualToString:@"username"]) {
        NSString *username = URL.host;
        // do something with this username
        // ...
        return NO;
    }
    return YES; // let the system open this URL
}

- (NSArray *)getDatesWithStartDate:(NSString *)startDate endDate:(NSString *)endDate {

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];

    //字符串转时间
    NSDateFormatter *matter = [[NSDateFormatter alloc] init];
    matter.dateFormat = @"yyyy-MM-dd";
    NSDate *start = [matter dateFromString:startDate];
    NSDate *end = [matter dateFromString:endDate];

    NSMutableArray *componentAarray = [NSMutableArray array];
    NSComparisonResult result = [start compare:end];
    NSDateComponents *comps;
    while (result != NSOrderedDescending) {
        comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |  NSCalendarUnitWeekday fromDate:start];
        [componentAarray addObject:start];
           //后一天
        comps.day += 1;
        start = [calendar dateFromComponents:comps];
           //对比日期大小
        result = [start compare:end];
    }
    return componentAarray;
}

@end
