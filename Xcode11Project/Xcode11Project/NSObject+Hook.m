//
//  NSObject+Hook.m
//  Xcode11Project
//
//  Created by Bin Shang on 2020/7/4.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#import "NSObject+Hook.h"

@implementation NSObject (Hook)

BOOL swizzleInstanceMethod(Class clz, SEL origSelector, SEL replSelector){
    //    NSLog(@"%@,%@,%@",self,self.class,object_getClass(self));
    if (!clz || !origSelector || !replSelector) {
        NSLog(@"Nil Parameter(s) found when swizzling.");
        return NO;
    }
    
    //1. 通过class_getInstanceMethod()函数从当前对象中的method list获取method结构体，如果是类方法就使用class_getClassMethod()函数获取。
    Method original = class_getInstanceMethod(clz, origSelector);
    Method replace = class_getInstanceMethod(clz, replSelector);
    if (!original || !replace) {
        NSLog(@"Swizzling Method(s) not found while swizzling class %@.", NSStringFromClass(clz));
        return NO;
    }

    if (class_addMethod(clz, origSelector, method_getImplementation(replace), method_getTypeEncoding(replace))) {
        class_replaceMethod(clz, replSelector, method_getImplementation(original), method_getTypeEncoding(original));
    } else {
        method_exchangeImplementations(original, replace);
    }
    return YES;
}

BOOL swizzleClassMethod(Class clz, SEL origSelector, SEL replSelector){
    //    NSLog(@"%@,%@,%@",self,self.class,object_getClass(self));
    if (!clz || !origSelector || !replSelector) {
        NSLog(@"Nil Parameter(s) found when swizzling.");
        return NO;
    }
    clz = object_getClass(clz);
//    Class metaClass = objc_getMetaClass(class_getName(clz));

    Method original = class_getClassMethod(clz, origSelector);
    Method replace = class_getClassMethod(clz, replSelector);
    if (!original || !replace) {
        NSLog(@"Swizzling Method(s) not found while swizzling class %@.", NSStringFromClass(clz));
        return NO;
    }
    
    if (class_addMethod(clz, origSelector, method_getImplementation(replace), method_getTypeEncoding(replace))) {
        class_replaceMethod(clz, replSelector, method_getImplementation(original), method_getTypeEncoding(original));
    } else {
        method_exchangeImplementations(original, replace);
    }
    return YES;
}

@end


@implementation NSArray (Hook)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        swizzleInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndex:), @selector(safe_objectAtIndex:));
        swizzleInstanceMethod(NSClassFromString(@"__NSArrayI"), @selector(objectAtIndexedSubscript:), @selector(safe_objectAtIndexedSubscript:));


        NSArray *array = @[NSStringFromSelector(@selector(objectAtIndex:)),
                           NSStringFromSelector(@selector(objectAtIndexedSubscript:)),
                           NSStringFromSelector(@selector(insertObject:atIndex:)),
                           NSStringFromSelector(@selector(setObject:atIndexedSubscript:)),
                           NSStringFromSelector(@selector(insertObjects:atIndexes:))
                                        ];
        for (NSString *str in array) {
            swizzleInstanceMethod(NSClassFromString(@"__NSArrayM"),
                                  NSSelectorFromString(str),
                                  NSSelectorFromString([@"safe_" stringByAppendingString:str]));
        }
    });
}

- (id)safe_objectAtIndex:(NSUInteger)index {
    NSUInteger count = self.count;
    if (count == 0 || index >= count) {
        return nil;
    }
    return [self safe_objectAtIndex:index];
}

- (id)safe_objectAtIndexedSubscript:(NSUInteger)index {
    NSUInteger count = self.count;
    if (count == 0 || index >= count) {
        return nil;
    }
    return [self safe_objectAtIndexedSubscript:index];
}


@end


@implementation NSMutableArray (Hook)

- (id)safe_objectAtIndex:(NSUInteger)index {
    NSUInteger count = self.count;
    if (count == 0 || index >= count) {
        return nil;
    }
    return [self safe_objectAtIndex:index];
}

- (id)safe_objectAtIndexedSubscript:(NSUInteger)index {
    NSUInteger count = self.count;
    if (count == 0 || index >= count) {
        return nil;
    }
    return [self safe_objectAtIndexedSubscript:index];
}

- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index {
    if (!anObject) return;
    [self safe_insertObject:anObject atIndex:index];
}

- (void)safe_setObject:(id)anObject atIndexedSubscript:(NSUInteger)index {
    if (!anObject) return;
    [self safe_setObject:anObject atIndexedSubscript:index];
}

- (void)safe_insertObjects:(NSArray *)objects atIndexes:(NSIndexSet *)indexes {
    if (objects && objects.count == indexes.count) {
        [self safe_insertObjects:objects atIndexes:indexes];
    }
}

@end


@implementation NSDictionary (Hook)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(setObject:forKeyedSubscript:), @selector(safe_setObject:forKeyedSubscript:));

        swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"),
                              @selector(setObject:forKey:),
                              @selector(safe_setObject:forKey:));

        swizzleInstanceMethod(NSClassFromString(@"__NSDictionaryM"), @selector(removeObjectForKey:), @selector(safe_removeObjectForKey:));
    });
}

- (void)safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject && aKey) {
        [self safe_setObject:anObject forKey:aKey];
    }
}

- (void)safe_setObject:(id)anObject forKeyedSubscript:(id<NSCopying>)aKey {
    if (anObject && aKey) {
        [self safe_setObject:anObject forKeyedSubscript:aKey];
    }
}

- (void)safe_removeObjectForKey:(id<NSCopying>)aKey {
    if (aKey) {
        [self safe_removeObjectForKey:aKey];
    }
}

@end


@implementation NSString (Hook)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(substringToIndex:), @selector(safe_substringToIndex:));

        swizzleInstanceMethod(NSClassFromString(@"__NSCFConstantString"), @selector(objectForKeyedSubscript:), @selector(safe_objectForKeyedSubscript:));
        
        /* NSTaggedPointerString */
        swizzleInstanceMethod(NSClassFromString(@"NSTaggedPointerString"), @selector(substringFromIndex:), @selector(safe_substringFromIndex:));
        swizzleInstanceMethod(NSClassFromString(@"NSTaggedPointerString"), @selector(substringToIndex:), @selector(safe_substringToIndex:));
        swizzleInstanceMethod(NSClassFromString(@"NSTaggedPointerString"), @selector(substringWithRange:), @selector(safe_substringWithRange:));
        
    });
}

- (NSString *)safe_substringToIndex:(NSUInteger)to {
    if (to > self.length) {
        return nil;
    }
    return [self safe_substringToIndex:to];
}

- (id)safe_objectForKeyedSubscript:(NSString *)key {
    return nil;
}

- (NSString *)safe_substringFromIndex:(NSUInteger)from{
    if (from <= self.length) {
        return [self safe_substringFromIndex:from];
    }
    return nil;
}

- (NSString *)safe_substringWithRange:(NSRange)range{
    if (range.location + range.length <= self.length) {
        return [self safe_substringWithRange:range];
    } else if (range.location < self.length){
        return [self safe_substringWithRange:NSMakeRange(range.location, self.length-range.location)];
    }
    return nil;
}

@end


@implementation NSMutableString (Hook)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleInstanceMethod(NSClassFromString(@"__NSCFString"), @selector(replaceCharactersInRange:withString:), @selector(safe_replaceCharactersInRange:withString:));

        swizzleInstanceMethod(NSClassFromString(@"__NSCFString"), @selector(objectForKeyedSubscript:), @selector(safe_objectForKeyedSubscript:));

    });
}

- (void)safe_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    if ((range.location + range.length) > self.length) {
        NSLog(@"error: Range or index out of bounds");
    }else {
        [self safe_replaceCharactersInRange:range withString:aString];
    }
}

- (id)safe_objectForKeyedSubscript:(NSString *)key {
    return nil;
}

@end


@implementation NSMutableAttributedString (Hook)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleInstanceMethod(NSClassFromString(@"NSConcreteMutableAttributedString"), @selector(replaceCharactersInRange:withString:), @selector(safe_replaceCharactersInRange:withString:));

    });
}

- (void)safe_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString {
    if ((range.location + range.length) > self.length) {
        NSLog(@"error: Range or index out of bounds");
    } else {
        [self safe_replaceCharactersInRange:range withString:aString];
    }
}

@end
