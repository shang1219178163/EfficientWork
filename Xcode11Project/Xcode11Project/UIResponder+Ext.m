//
//  UIResponder+Ext.m
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/29.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "UIResponder+Ext.h"

@implementation UIResponder (Ext)

-(UIResponder *_Nullable)nextResponder:(NSString *)responderName{
    UIResponder *next = self.nextResponder;
    while (next){
        if ([next isKindOfClass:[NSClassFromString(responderName) class]]){
            return next;
        }
        next = [next nextResponder];
    }
    return nil;
}


@end
