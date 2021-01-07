//
//  UIApplication+ZBUserOperationMonitor.h
//  ZBUserOperationMonitor
//
//  Created by 隐姓埋名 on 2021/1/7.
//  Copyright © 2021 展斌程. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (ZBUserOperationMonitor)
/// event hook
+ (void)zbUserOperationMonitorHook;
/// event unhook
+ (void)zbUserOperationMonitorUnHook;
@end

NS_ASSUME_NONNULL_END
