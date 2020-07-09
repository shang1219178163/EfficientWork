//
//  NSObject+Hook.h
//  Xcode11Project
//
//  Created by Bin Shang on 2020/7/4.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Hook)

/**
 (源方法)实例方法交换

 @param clz     Class或者NSString类型
 @return        YES成功,NO失败
 */
FOUNDATION_EXPORT BOOL swizzleInstanceMethod(Class clz, SEL origSelector, SEL replSelector);

/**
 (源方法)类方法交换
 
 @param clz     Class或者NSString类型
 @return        YES成功,NO失败
 */
FOUNDATION_EXPORT BOOL swizzleClassMethod(Class clz, SEL origSelector, SEL replSelector);

@end


@interface NSArray (Hook)

@end

@interface NSMutableArray (Hook)

@end


@interface NSDictionary (Hook)

@end


@interface NSString (Hook)

@end


@interface NSMutableString (Hook)

@end


@interface NSMutableAttributedString (Hook)

@end


NS_ASSUME_NONNULL_END


