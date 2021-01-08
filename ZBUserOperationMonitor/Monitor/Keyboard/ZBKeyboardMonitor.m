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

/// 可以监控所有键盘输入的行为，但对于模拟器使用电脑键盘直接输入无能为力（正常手机设备不会有这种情况发生）
+ (void)keyboardMonitor {
    /// monitor keyboard
    [[NSNotificationCenter defaultCenter] addObserverForName:ZBUserOperationMonitor_keyboardPressDownNotification object:nil queue:NSOperationQueue.mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        UITouch *touch = note.object;
        id keyboardImpl = [self getResponderWithView:touch.view className:@"UIKeyboardImpl"];
        id delegate = [keyboardImpl valueForKey:@"delegate"];
        if ([delegate isKindOfClass:NSClassFromString(@"UITextField")]) {// 如果是原生的UITextField
            UITextField *textField = (UITextField *)delegate;
            NSLog(@"[(UIApplication + ZBUserOperationMonitor) - %s] - textField：%@",__func__,textField.text);
        }else if ([delegate isKindOfClass:NSClassFromString(@"UITextView")]) {// 如果是原生的UITextView
            UITextView *textView = (UITextView *)delegate;
            NSLog(@"[(UIApplication + ZBUserOperationMonitor) - %s] - textView：%@",__func__,textView.text);
        }else if ([delegate isKindOfClass:NSClassFromString(@"DOMHTMLInputElement")]) {// 如果是Webview的INPUT
            id node = [delegate valueForKey:@"_node"];
            NSString *text = [node valueForKey:@"value"];
            NSLog(@"[(UIApplication + ZBUserOperationMonitor) - %s] - DOMHTMLInputElement：%@",__func__,text);
        }else if ([delegate isKindOfClass:NSClassFromString(@"DOMHTMLTextAreaElement")]) {// 如果是Webview的TEXTAREA
            id node = [delegate valueForKey:@"_node"];
            NSString *text = [node valueForKey:@"value"];
            NSLog(@"[(UIApplication + ZBUserOperationMonitor) - %s] - DOMHTMLTextAreaElement：%@",__func__,text);
        }
//        NSString *responderTree = [self getResponderTree:touch.view];
//        printf("\nresponderTree：%s\n",[responderTree UTF8String]);
//        NSString *viewTree = [self getViewTree:touch.view];
//        printf("\nviewTree：%s\n",[viewTree UTF8String]);
    }];
}

#pragma mark - responder method
+ (id)getResponderWithView:(UIView *)view className:(NSString *)className {
    UIResponder *currentResponder = view;
    while (currentResponder) {
        if ([NSStringFromClass(currentResponder.class) isEqualToString:className]) {
            return currentResponder;
        }
        currentResponder = currentResponder.nextResponder;
    }
    return nil;
}

+ (NSString *)getResponderTree:(UIView *)view {
    NSString *responderString = @"";
    UIResponder *currentResponder = view;
    while (currentResponder) {
        responderString = [responderString stringByAppendingFormat:@" - %@",NSStringFromClass([currentResponder class])];
        currentResponder = currentResponder.nextResponder;
    }
    return responderString;
}

+ (NSString *)getViewTree:(UIView *)view {
    NSString *viewString = @"";
    UIView *currentView = view;
    while (currentView) {
        viewString = [viewString stringByAppendingFormat:@" - %@",NSStringFromClass([currentView class])];
        currentView = currentView.superview;
    }
    return viewString;
}
@end
