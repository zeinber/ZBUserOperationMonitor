//
//  ZBHooker.m
//
//  Created by zeinber on 2018/4/1.
//  Copyright © 2018年 zeinber. All rights reserved.
//

#import "ZBHooker.h"
#import <objc/runtime.h>

@implementation ZBHooker

+ (void)hookInstance:(NSString *)oriClass sel:(NSString *)oriSel withClass:(NSString *)newClass andSel:(NSString *)newSel {
    Class hookedClass = objc_getClass([oriClass UTF8String]);
    Class swizzledClass = objc_getClass([newClass UTF8String]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL oriSelector = NSSelectorFromString(oriSel);
    SEL swizzledSelector = NSSelectorFromString(newSel);
#pragma clang diagnostic pop
    Method originalMethod = class_getInstanceMethod(hookedClass, oriSelector);
    Method swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSelector);
    if (class_addMethod(hookedClass, oriSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(hookedClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)hookClass:(NSString *)oriClass sel:(NSString *)oriSel withClass:(NSString *)newClass andSel:(NSString *)newSel {
    Class hookedClass = objc_getClass([oriClass UTF8String]);
    Class swizzledClass = objc_getClass([newClass UTF8String]);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL oriSelector = NSSelectorFromString(oriSel);
    SEL swizzledSelector = NSSelectorFromString(newSel);
#pragma clang diagnostic pop
    Method originalMethod = class_getClassMethod(hookedClass, oriSelector);
    Method swizzledMethod = class_getClassMethod(swizzledClass, swizzledSelector);
    if (class_addMethod(hookedClass, oriSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
        class_replaceMethod(hookedClass, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
