//
//  ZBClipboardMonitor.m
//  ZBUserOperationMonitor
//
//  Created by 隐姓埋名 on 2021/1/7.
//  Copyright © 2021 展斌程. All rights reserved.
//

#import "ZBClipboardMonitor.h"
#import <UIKit/UIKit.h>
#import "ZBViewTool.h"

extern NSString *ZBUserOperationMonitor_clipboardPressUpNotification;

@implementation ZBClipboardMonitor
#pragma mark - load
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [ZBClipboardMonitor clipboardMonitor];
    });
}

#pragma mark - monitor
/// 可以监控用户操作剪切板的行为，包括复制、粘贴和剪切
+ (void)clipboardMonitor {
    /// monitor keyboard
    [[NSNotificationCenter defaultCenter] addObserverForName:ZBUserOperationMonitor_clipboardPressUpNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        UITouch *touch = note.object;
        if ([touch.view respondsToSelector:@selector(action)]) {//click selector
            void *action_ptr = (__bridge void *)([touch.view performSelector:@selector(action)]);
            const char *action = (const char*)action_ptr;
            if (action) {
                NSString *actionStr = [NSString stringWithUTF8String:action];
                if ([actionStr isEqualToString:@"copy:"]) {//is copy action
                   NSLog(@"[%s] - 复制",__func__);
                }else if ([actionStr isEqualToString:@"paste:"]) {//is paste action
                    NSLog(@"[%s] - 粘贴",__func__);
                }else if ([actionStr isEqualToString:@"cut:"]) {//is cut action
                    NSLog(@"[%s] - 剪切",__func__);
                }
            }
        }
    }];
}
@end
