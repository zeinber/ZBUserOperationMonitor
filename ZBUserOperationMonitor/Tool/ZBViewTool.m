//
//  ZBViewTool.m
//  ZBUserOperationMonitor
//
//  Created by 隐姓埋名 on 2021/1/8.
//  Copyright © 2021 展斌程. All rights reserved.
//

#import "ZBViewTool.h"

@implementation ZBViewTool
#pragma mark - public method
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
