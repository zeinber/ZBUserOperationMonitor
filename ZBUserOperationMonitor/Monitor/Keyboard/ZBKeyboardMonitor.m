//
//  ZBKeyboardMonitor.m
//  ZBUserOperationMonitor
//
//  Created by 隐姓埋名 on 2021/1/7.
//  Copyright © 2021 展斌程. All rights reserved.
//

#import "ZBKeyboardMonitor.h"
#import <UIKit/UIKit.h>
#import "ZBHooker.h"

extern NSString *ZBUserOperationMonitor_keyboardPressDownNotification;

@implementation ZBKeyboardMonitor
#pragma mark - load
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [ZBKeyboardMonitor textMonitor];
        [ZBKeyboardMonitor keyboardMonitor];
    });
}

#pragma mark - monitor
/// 只能监控原生文本框textField 和 textView的输入，对于WebView的input和textarea无能为力
+ (void)textMonitor {
    /// monitor textField
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        UITextField *textField = note.object;
        NSLog(@"[keyboardMonitor - %s] - textField：%@",__func__,textField.text);
    }];
    /// monitor textView
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextViewTextDidChangeNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        UITextView *textView = note.object;
        NSLog(@"[keyboardMonitor - %s] - textView：%@",__func__,textView.text);
    }];
}

/// 可以监控所有键盘输入的行为
+ (void)keyboardMonitor {
    /// monitor keyboard
    [[NSNotificationCenter defaultCenter] addObserverForName:ZBUserOperationMonitor_keyboardPressDownNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        UITouch *touch = note.object;
        NSLog(@"[keyboardMonitor - %s] - keyboard：%@",__func__,touch);
    }];
}
@end
