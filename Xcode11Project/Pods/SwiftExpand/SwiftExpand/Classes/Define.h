//
//  Define.h
//  SwiftExpand
//
//  Created by Bin Shang on 2019/12/18.
//

#ifndef Define_h
#define Define_h

#ifdef DEBUG
#define DDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

//#define DDLog(FORMAT, ...) {\
//NSString *formatStr = @"yyyy-MM-dd HH:mm:ss.SSS";\
//NSMutableDictionary *threadDic = NSThread.currentThread.threadDictionary;\
//NSDateFormatter *formatter = [threadDic objectForKey:formatStr];\
//if (!formatter) {\
//formatter = [[NSDateFormatter alloc]init];\
//formatter.dateFormat = formatStr;\
//formatter.locale = [NSLocale currentLocale];\
//formatter.timeZone = [NSTimeZone systemTimeZone];\
//[threadDic setObject:formatter forKey:formatStr];\
//}\
//NSString *str = [formatter stringFromDate:NSDate.date];\
//fprintf(stderr,"%s【line -%d】%s %s ", [str UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
//}

#else
#define DDLog(...)
#endif


#if __has_feature(objc_arc)
// ARC
#else
// MRC
#endif

#if TARGET_OS_IPHONE
//iPhone Device
#endif
#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif


/*--------------------------------MacroGeometry------------------------------------------------------*/
#pragma mark - Geometry

//屏幕 rect
#define kScreenWidth        (UIScreen.mainScreen.bounds.size.width)
#define kScreenHeight       (UIScreen.mainScreen.bounds.size.height)

#define kSizeArrow          CGSizeMake(25.0, 35.0)
#define kSizeBSelected      CGSizeMake(35.0, 35.0)


#pragma mark - others

#define dispatch_main_sync_safe(block)                    \
if ([NSThread isMainThread]) {                        \
block();                                          \
} else {                                              \
dispatch_sync(dispatch_get_main_queue(), block);  \
}

#define dispatch_main_async_safe(block)                   \
if ([NSThread isMainThread]) {                        \
block();                                          \
} else {                                              \
dispatch_async(dispatch_get_main_queue(), block); \
}


/**
 YYKit
 Synthsize a weak or strong reference.
 
 Example:
 @weakify(self)
 [self doSomething^{
 @strongify(self)
 if (!self) return;
 ...
 }];
 
 */
#ifndef weakify
    #if DEBUG
        #define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
    #else
        #define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
    #else
        #define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
    #endif
#endif


#endif /* Define_h */
