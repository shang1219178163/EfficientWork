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
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, CGRectGetWidth(self.view.bounds) - 20, 100)];
    textView.font = [UIFont systemFontOfSize:16];
    
    NSArray *tapText = @[@"marcelofabri", @"one", @"two"];
    NSString *string = [NSString stringWithFormat:@"This is %@ an example %@ by qeqwe wewer tryrty rtert %@", tapText[0], tapText[1], tapText[2]];
        
    
    NSDictionary *attDic = @{
        NSForegroundColorAttributeName: UIColor.grayColor,
        NSFontAttributeName: [UIFont systemFontOfSize:15],
    };
    
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attDic];
    [attributedString addAttribute:NSLinkAttributeName
                         value:@"username://marcelofabri"
                         range:[attributedString.string rangeOfString:tapText[0]]];
    
    [attributedString addAttribute:NSLinkAttributeName
                         value:@"one://1111"
                         range:[attributedString.string rangeOfString:tapText[1]]];
    
    [attributedString addAttribute:NSLinkAttributeName
                         value:@"two://2222"
                         range:[attributedString.string rangeOfString:tapText[2]]];

    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                 NSUnderlineColorAttributeName: [UIColor lightGrayColor],
//                                 NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)
                                     
    };

    // assume that textView is a UITextView previously created (either by code or Interface Builder)
    textView.linkTextAttributes = linkAttributes; // customizes the appearance of links
    textView.attributedText = attributedString;
    textView.delegate = self;
    textView.selectable = true;
    textView.editable = false;
    
    [self.view addSubview:textView];
    
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

@end
