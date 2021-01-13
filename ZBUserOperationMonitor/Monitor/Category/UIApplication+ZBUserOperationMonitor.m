//
//  UIApplication+ZBUserOperationMonitor.m
//  ZBUserOperationMonitor
//
//  Created by 隐姓埋名 on 2021/1/7.
//  Copyright © 2021 展斌程. All rights reserved.
//

#import "UIApplication+ZBUserOperationMonitor.h"
#import "ZBHooker.h"

/// 点击键盘后抬起时的通知
NSString *ZBUserOperationMonitor_keyboardPressUpNotification = @"ZBUserOperationMonitor_keyboardPressUpNotification";

/// 点击剪切板工具栏时抬起时的回调
NSString *ZBUserOperationMonitor_clipboardPressUpNotification = @"ZBUserOperationMonitor_clipboardPressUpNotification";

@implementation UIApplication (ZBUserOperationMonitor)
#pragma mark - load
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIApplication zbUserOperationMonitorHook];
    });
}
#pragma mark - public method
/// event hook
+ (void)zbUserOperationMonitorHook {
    [ZBHooker hookInstance:@"UIApplication" sel:@"sendEvent:" withClass:@"UIApplication" andSel:@"zbUserOperationMonitorHook_sendEvent:"];
}

/// event unhook
+ (void)zbUserOperationMonitorUnHook {
    [ZBHooker hookInstance:@"UIApplication" sel:@"zbUserOperationMonitorHook_sendEvent:" withClass:@"UIApplication" andSel:@"sendEvent:"];
}

#pragma mark - hook method
/// 根据响应链我们知道事件将会通过[UIApplication sendEvent:]的方式发送到事件处理中心进行处理，所以我们只要在此过滤出UITouch事件后，再从里面筛选出键盘点击事件和剪切板操作就行了
- (void)zbUserOperationMonitorHook_sendEvent:(UIEvent *)event {
    // orig call
    [self zbUserOperationMonitorHook_sendEvent:event];
    // you need do
    
    if (event && [event isKindOfClass:[NSNull class]]) {
        event = nil;
    }
    UITouch *touch = event.allTouches.allObjects.lastObject;
    if (!touch) {//无touch，不是点击事件
        return;
    }
    
    // 处理点击事件 - 获取手指PressUp的状态
    if (touch.phase == UITouchPhaseEnded) {
        // 是键盘点击事件
        if ([self isKeyboardWithTouch:touch]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ZBUserOperationMonitor_keyboardPressUpNotification object:touch userInfo:nil];
        }else if ([self isClipboardWithTouch:touch]) {// 点击剪切板工具栏时抬起时的回调
            [[NSNotificationCenter defaultCenter] postNotificationName:ZBUserOperationMonitor_clipboardPressUpNotification object:touch userInfo:nil];
        }
    }
}

#pragma mark - private method
- (BOOL)isKeyboardWithTouch:(UITouch *)touch {
    // window 为UIRemoteKeyboardWindow，说明touch在键盘上
    return [touch.window isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")];
}

- (BOOL)isClipboardWithTouch:(UITouch *)touch {
    // view 为UICalloutBarButton且window为UITextEffectsWindow，说明touch在工具栏上
    return [touch.view isKindOfClass:NSClassFromString(@"UICalloutBarButton")] && [touch.window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")];
}

@end
