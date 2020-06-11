//
//  Macro.h
//  Xcode11Project
//
//  Created by Bin Shang on 2020/6/11.
//  Copyright © 2020 Bin Shang. All rights reserved.
//

#ifndef Macro_h
#define Macro_h


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

#endif /* Macro_h */
