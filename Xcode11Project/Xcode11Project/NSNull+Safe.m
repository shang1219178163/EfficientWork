//
//  NSNull+Safe.m
//  Xcode11Project
//
//  Created by Bin Shang on 2020/7/4.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "NSNull+Safe.h"

@implementation NSNull (Safe)

#if TARGET_IPHONE_SIMULATOR

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSString *string = @"++++++++++++++++++++++";
    return string;
}
#endif

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([self respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:self];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature *methodSignature = [[NSNull class] instanceMethodSignatureForSelector:selector];
    if (!methodSignature) {
        methodSignature = [NSMethodSignature signatureWithObjCTypes:"@:"]; // `@:`是随便定义的有效type encodings
    }
    return methodSignature;
}

@end
