//
//  UIResponder+Ext.h
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/29.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (Ext)

-(UIResponder * _Nullable)nextResponder:(NSString *)responderName;

@end

NS_ASSUME_NONNULL_END
